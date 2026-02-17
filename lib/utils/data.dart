import 'package:own_yourself/utils/types.dart';

List<Habit> data = [
  Habit(
    id: '6c84fb90-12c4-11e1-840d-7b25c5ee775a',
    title: "Exercise",
    repetitionType: HabitRepetitionType.daily,
    repetitionTimes: 1,
    startDate: DateTime.now(),
    endDate: DateTime.now().add(Duration(days: 30)),
  ),
  Habit(
    id: '6c84fb90-12c4-11e1-840d-7b25c5ee775b',
    title: "Meditation",
    repetitionType: HabitRepetitionType.daily,
    repetitionTimes: 2,
    startDate: DateTime.now(),
    endDate: DateTime.now().add(Duration(days: 30)),
  ),
  Habit(
    id: '6c84fb90-12c4-11e1-840d-7b25c5ee775c',
    title: "Reading",
    repetitionType: HabitRepetitionType.daily,
    repetitionTimes: 3,
    startDate: DateTime.now(),
    endDate: DateTime.now().add(Duration(days: 30)),
  ),
];
