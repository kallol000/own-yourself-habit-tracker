import 'package:drift/drift.dart';
import 'package:own_yourself/database/tables/habits.dart';
import 'package:own_yourself/utils/helper_functions.dart';


class HabitLogs extends Table {
  IntColumn get id => integer().autoIncrement()();

  // Links this log entry to a specific habit
  IntColumn get habitId => integer().references(Habits, #id, onDelete: KeyAction.cascade)();

  // The specific date/time the habit was performed
  TextColumn get completedAt => text().map(const DateTimeConverter())();

  // Useful if the habit is "Drink 8 glasses of water" and they only drank 2
  IntColumn get value => integer().withDefault(const Constant(1))();

  // Optional: Add a note for specific entries
  TextColumn get note => text().nullable()();
}