import 'package:drift/drift.dart';
import 'package:own_yourself/database/tables/habits.dart';

class HabitLogs extends Table {
  IntColumn get id => integer().autoIncrement()();

  // The correct way to reference the habits table with a cascade delete
  IntColumn get habitId => integer().references(
    Habits,
    #id,
    onDelete: KeyAction.cascade, // Updated from Operation to KeyAction
  )();

  TextColumn get completedAt => text()();

  IntColumn get value => integer().withDefault(const Constant(1))();

  TextColumn get note => text().nullable()();
}

class DateTimeConverter extends TypeConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime fromSql(String fromDb) => DateTime.parse(fromDb);

  @override
  String toSql(DateTime value) => value.toIso8601String();
}
