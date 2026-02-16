class Habit {
  final String id;
  final String title;
  final HabitRepetitionType repetitionType;
  final int repetitionTimes;
  final DateTime startDate;
  final DateTime endDate;

  Habit({
    required this.id,
    required this.title,
    required this.repetitionType,
    this.repetitionTimes = 1,
    required this.startDate,
    required this.endDate,
  });
}

enum HabitRepetitionType { daily, weekly, monthly }

List<int> HabitRepetitionTimes = [
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  14,
  15,
  16,
  17,
  18,
  19,
  20,
  21,
  22,
  23,
  24,
  25,
  26,
  27,
  28,
  29,
  30,
  31,
];
