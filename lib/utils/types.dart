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

  Map<String, dynamic> toMap() {
  return {
    'id': id,
    'title': title,
    'habitRepetitionType': repetitionType.name, // enum → String
    'habitRepetitionTimes': repetitionTimes,
    'startDate': startDate.toIso8601String(), // DateTime → String
    'endDate': endDate.toIso8601String(),
  };
}
}

enum HabitRepetitionType { daily, weekly, monthly }

Map<HabitRepetitionType, String> habitRepetitionTypeNames = {
  HabitRepetitionType.daily: "daily",
  HabitRepetitionType.weekly: "a week",
  HabitRepetitionType.monthly: "a month",
};

