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

  // Habits methods
  Stream<List<Habit>> watchHabits() =>
      select(habits).watch(); // stream existing habits
  Future<int> insertHabit(HabitsCompanion habit) =>
      into(habits).insert(habit); //insert a new habit
  Future<int> deleteHabit(int id) {
    return (delete(habits)..where((habits) => habits.id.isValue(id))).go();
  } // delete an existing habit

  //Habitlog methods
  // Create a new log entry (e.g., user clicked "Complete" for today)
  Future<int> insertLog(HabitLogsCompanion log) => into(habitLogs).insert(log);

  // Get all logs for a specific habit (useful for history/stats)
  Stream<List<HabitLog>> watchLogsForHabit(int habitId) {
    return (select(habitLogs)..where((t) => t.habitId.equals(habitId))).watch();
  }

  // Delete a specific log entry if they made a mistake
  Future<int> deleteLog(int logId) =>
      (delete(habitLogs)..where((t) => t.id.equals(logId))).go();

  Stream<List<HabitWithLogs>> watchHabitsWithLogs() {
    // 1. Start with the habits table
    final query = select(habits).join([
      // 2. Join habit_logs where the habitId matches
      leftOuterJoin(habitLogs, habitLogs.habitId.equalsExp(habits.id)),
    ]);

    // 3. Transform the flat rows into our HabitWithLogs objects
    return query.watch().map((rows) {
      final Map<Habit, List<HabitLog>> grouped = {};

      for (final row in rows) {
        final habit = row.readTable(habits);
        final log = row.readTableOrNull(habitLogs);

        // Initialize the list for this habit if it doesn't exist
        grouped.putIfAbsent(habit, () => []);

        // If a log exists for this row, add it to the list
        if (log != null) {
          grouped[habit]!.add(log);
        }
      }

      return grouped.entries
          .map((entry) => HabitWithLogs(habit: entry.key, logs: entry.value))
          .toList();
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
