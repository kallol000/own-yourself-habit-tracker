import 'package:own_yourself/utils/types.dart';

List<HabitEntity> data = [
  HabitEntity(
    id: 1,
    title: "Exercise",
    repetitionType: HabitRepetitionType.daily,
    repetitionTimes: 1,
    startDate: DateTime.now(),
    endDate: DateTime.now().add(Duration(days: 30)),
  ),
  HabitEntity(
    id: 2,
    title: "Meditation",
    repetitionType: HabitRepetitionType.daily,
    repetitionTimes: 2,
    startDate: DateTime.now(),
    endDate: DateTime.now().add(Duration(days: 30)),
  ),
  HabitEntity(
    id: 3,
    title: "Reading",
    repetitionType: HabitRepetitionType.daily,
    repetitionTimes: 3,
    startDate: DateTime.now(),
    endDate: DateTime.now().add(Duration(days: 30)),
  ),
];
