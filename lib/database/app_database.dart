import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:own_yourself/utils/helper_functions.dart';
import 'tables/habits.dart';
import 'tables/habit_logs.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Habits, HabitLogs])
class AppDatabase extends _$AppDatabase {
  // Use a singleton pattern so only one connection exists
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;

  AppDatabase._internal() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        // This creates the new table during the upgrade
        await m.createTable(habitLogs);
      }
    },
    beforeOpen: (details) async {
      // Essential for the 'onDelete: KeyAction.cascade' logic to work
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  // Habits methods
  Stream<List<Habit>> watchHabits() =>
      select(habits).watch(); // stream existing habits
  Future<int> insertHabit(HabitsCompanion habit) =>
      into(habits).insert(habit); //insert a new habit
  Future<int> deleteHabit(int id) {
    return (delete(habits)..where((habits) => habits.id.isValue(id))).go();
  }

  Stream<Habit> watchHabitById(int id) {
    return (select(habits)..where((h) => h.id.equals(id))).watchSingle();
  }

  // --- HabitLogs Methods ---

  // Create a new log entry (e.g., user clicked "Complete" for today)
  Future<int> insertLog(HabitLogsCompanion log) => into(habitLogs).insert(log);

  // Get all logs for a specific habit (useful for history/stats)
  Stream<List<HabitLog>> watchLogsForHabit(int habitId) {
    return (select(habitLogs)..where((t) => t.habitId.equals(habitId))).watch();
  }

  // Delete a specific log entry if they made a mistake
  Future<int> deleteLog(int logId) =>
      (delete(habitLogs)..where((t) => t.id.equals(logId))).go();

  // toggle habit entry for a specific date (e.g., mark as complete or undo)
  Future<void> toggleHabitLog(int habitId, DateTime date) async {
    // 1. Normalize to midnight and convert to ISO String
    // This results in "2026-03-04T00:00:00.000"
    final String dateString = DateTime(
      date.year,
      date.month,
      date.day,
    ).toIso8601String();

    // 2. Check for existing log using the String directly
    final query = select(habitLogs)
      ..where((t) => t.habitId.equals(habitId))
      ..where((t) => t.completedAt.equals(dateString));

    final existingLog = await query.getSingleOrNull();

    if (existingLog != null) {
      // 3. Delete if found
      await (delete(habitLogs)..where((t) => t.id.equals(existingLog.id))).go();
    } else {
      // 4. Insert if not found
      // If your compiler still complains here, use Value(dateString)
      await into(habitLogs).insert(
        HabitLogsCompanion.insert(habitId: habitId, completedAt: dateString),
      );
    }
  }

  Stream<List<HabitWithLogs>> watchHabitsWithLast7DaysLogs() {
    // 1. Calculate the threshold (7 days ago at midnight)
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    final normalizedDate = DateTime(
      sevenDaysAgo.year,
      sevenDaysAgo.month,
      sevenDaysAgo.day,
    );

    // 2. Convert to ISO 8601 String to match the DB storage format
    final String thresholdString = normalizedDate.toIso8601String();

    final query = select(habits).join([
      leftOuterJoin(
        habitLogs,
        habitLogs.habitId.equalsExp(habits.id) &
            // Use the String here to satisfy the SQL requirement
            habitLogs.completedAt.isBiggerOrEqualValue(thresholdString),
      ),
    ]);

    return query.watch().map((rows) {
      final Map<Habit, List<HabitLog>> grouped = {};

      for (final row in rows) {
        final habit = row.readTable(habits);
        final log = row.readTableOrNull(habitLogs);

        grouped.putIfAbsent(habit, () => []);
        if (log != null) {
          grouped[habit]!.add(log);
        }
      }

      return grouped.entries
          .map((entry) => HabitWithLogs(habit: entry.key, logs: entry.value))
          .toList();
    });
  }

  Stream<HabitWithLogs> watchHabitWithLogsById(int habitId) {
    final query = select(habits).join([
      leftOuterJoin(
        habitLogs,
        habitLogs.habitId.equalsExp(habits.id),
      ),
    ])
      ..where(habits.id.equals(habitId));

    return query.watch().map((rows) {
      final habit = rows.first.readTable(habits);
      final logs = rows
          .map((row) => row.readTableOrNull(habitLogs))
          .whereType<HabitLog>()
          .toList();

      return HabitWithLogs(habit: habit, logs: logs);
    });
  }
}

class HabitWithLogs {
  final Habit habit;
  final List<HabitLog> logs;

  HabitWithLogs({required this.habit, required this.logs});
}

QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'habit_database',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  );
}
