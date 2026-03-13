import 'package:drift/drift.dart';
import 'package:own_yourself/database/tables/habit_logs.dart';

class Habits extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text()();

  TextColumn get habitRepetitionType => text()();

  IntColumn get habitRepetitionTimes => integer()();

  TextColumn get startDate => text().map(const DateTimeConverter())();

  IntColumn get bestStreak => integer().withDefault(const Constant(0))();

  IntColumn get currentStreak => integer().withDefault(const Constant(0))();

  TextColumn get endDate => text().map(const DateTimeConverter()).nullable()();
}
