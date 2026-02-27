class HabitEntity {
  final int? id;
  final String title;
  final HabitRepetitionType repetitionType;
  final int repetitionTimes;
  final DateTime startDate;
  final DateTime? endDate;

  HabitEntity({
    this.id,
    required this.title,
    required this.repetitionType,
    this.repetitionTimes = 1,
    required this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'title': title,
      'habitRepetitionType': repetitionType.name, // enum → String
      'habitRepetitionTimes': repetitionTimes,
      'startDate': startDate.toIso8601String(), // DateTime → String
      'endDate': endDate?.toIso8601String(),
    };
  }

  factory HabitEntity.fromMap(Map<String, dynamic> map) {
    return HabitEntity(
      id: map['id'] as int?,
      title: map['title'] as String,
      repetitionType: HabitRepetitionType.values.firstWhere(
        (e) => e.name == map['habitRepetitionType'],
      ),
      repetitionTimes: map['habitRepetitionTimes'] as int,
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: DateTime.parse(map['endDate'] as String),
    );
  }
}

enum HabitRepetitionType { daily, weekly, monthly }

Map<HabitRepetitionType, String> habitRepetitionTypeNames = {
  HabitRepetitionType.daily: "daily",
  HabitRepetitionType.weekly: "a week",
  HabitRepetitionType.monthly: "a month",
};
