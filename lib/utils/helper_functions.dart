import 'package:drift/drift.dart';
import 'package:own_yourself/utils/types.dart';
import '../utils/types.dart';

List<String> habitTimeOptions(HabitRepetitionType type) {
  switch (type) {
    case HabitRepetitionType.weekly:
      return List.generate(6, (index) => '${index + 1}');
    default:
      return List.generate(29, (index) => '${index + 1}');
  }
}

class DateTimeConverter extends TypeConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime fromSql(String fromDb) => DateTime.parse(fromDb);

  @override
  String toSql(DateTime value) => value.toIso8601String();
}

void getLastSevenDays() {
  DateTime now = DateTime.now();
  print(daysOfTheWeek);
}
