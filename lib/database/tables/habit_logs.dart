import 'package:drift/drift.dart';
import 'package:own_yourself/database/tables/habits.dart';

class HabitLogs extends Table {
  IntColumn get id => integer().references(Habits, #id)();

  TextColumn get title => text()();

  TextColumn get habitRepetitionType => text()();

  IntColumn get habitRepetitionTimes => integer()();

  DateTimeColumn get startDate => dateTime()();

  DateTimeColumn get endDate => dateTime().nullable()();
}