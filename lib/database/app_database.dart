import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables/habits.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Habits])
class AppDatabase extends _$AppDatabase {
  // Use a singleton pattern so only one connection exists
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;

  AppDatabase._internal() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<int> insertHabit(HabitsCompanion habit) => into(habits).insert(habit);

  Stream<List<Habit>> watchHabits() => select(habits).watch();

  Future<int> deleteHabit(int id) {
    return (delete(habits)..where((habits) => habits.id.isValue(id))).go();
  }
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
