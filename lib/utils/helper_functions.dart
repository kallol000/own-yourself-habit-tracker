import 'package:drift/drift.dart';
import 'package:own_yourself/database/app_database.dart';
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

class Node<Weekday> {
  Weekday value;
  Node<Weekday>? next;
  Node<Weekday>? prev;

  Node(this.value);
}

class Weekday {
  final String shortName;
  final String longName;
  final int isoId; // 1 for Monday, 7 for Sunday

  Weekday({
    required this.shortName,
    required this.longName,
    required this.isoId,
  });

  @override
  String toString() => "$longName ($shortName)";
}

class WeekdayTracker {
  Node<Weekday>? head;

  // Quick access to nodes by their ISO ID (1-7)
  final Map<int, Node<Weekday>> _nodeCache = {};

  WeekdayTracker() {
    final days = [
      Weekday(shortName: "Mon", longName: "Monday", isoId: 1),
      Weekday(shortName: "Tue", longName: "Tuesday", isoId: 2),
      Weekday(shortName: "Wed", longName: "Wednesday", isoId: 3),
      Weekday(shortName: "Thu", longName: "Thursday", isoId: 4),
      Weekday(shortName: "Fri", longName: "Friday", isoId: 5),
      Weekday(shortName: "Sat", longName: "Saturday", isoId: 6),
      Weekday(shortName: "Sun", longName: "Sunday", isoId: 7),
    ];

    for (var day in days) {
      _addNode(day);
    }
  }

  void _addNode(Weekday day) {
    var newNode = Node<Weekday>(day);
    _nodeCache[day.isoId] = newNode;

    if (head == null) {
      head = newNode;
      newNode.next = head;
      newNode.prev = head;
    } else {
      Node<Weekday> tail = head!.prev!;
      tail.next = newNode;
      newNode.prev = tail;
      newNode.next = head;
      head!.prev = newNode;
    }
  }

  // Get a list of N days starting from a specific ISO ID
  List<Weekday> getRange(int startId, int count) {
    List<Weekday> results = [];
    Node<Weekday>? current = _nodeCache[startId];

    for (int i = 0; i < count; i++) {
      if (current != null) {
        results.insert(0, current.value); // Add to the front for reverse order
        current = current.prev;
      }
    }
    return results;
  }
}

Map<int, String> weekdayMap = {
  1: "Mon",
  2: "Tue",
  3: "Wed",
  4: "Thu",
  5: "Fri",
  6: "Sat",
  7: "Sun",
};

List<String> getLastNDays(int numberOfDays) {
  List<String> result = [];
  DateTime today = DateTime.now();
  for (int i = 0; i < numberOfDays; i++) {
    DateTime finalDate = today.subtract(Duration(days: i));
    result.insert(0, weekdayMap[finalDate.weekday]!);
  }
  return result;
}

List<DateTime> getLastNWeekdays(int numberOfDays) {
  List<DateTime> result = [];
  DateTime today = DateTime.now();
  for (int i = 0; i < numberOfDays; i++) {
    DateTime finalDate = today.subtract(Duration(days: i));
    result.insert(0, finalDate);
  }
  return result;
}

class StreakCalculator {
  // Main entry point
  static int calculate(Habit habit, List<HabitLog> logs) {
    if (logs.isEmpty) return 0;

    // 1. Sort logs newest to oldest
    final sortedLogs = List<HabitLog>.from(logs)
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));

    // 2. Route to specific logic
    switch (habit.habitRepetitionType.toLowerCase()) {
      case 'daily':
        return _calculateDaily(habit, sortedLogs);
      case 'weekly':
        return _calculateWeekly(habit, sortedLogs);
      case 'monthly':
        return _calculateMonthly(habit, sortedLogs);
      default:
        return 0;
    }
  }

  // --- DAILY LOGIC ---
  static int _calculateDaily(Habit habit, List<HabitLog> logs) {
    int streak = 0;
    DateTime checkDate = DateTime.now().dateOnly;
    final logSet = logs.map((l) => l.completedAt).toSet();
    final startStr = habit.startDate.toIso8601String();

    // Loop backwards until we hit the start date
    while (checkDate.isAtSameMomentAs(habit.startDate) ||
        checkDate.isAfter(habit.startDate)) {
      String currentStr = checkDate.toIso8601String();

      if (logSet.contains(currentStr)) {
        streak++;
      } else {
        // If it's today and not done yet, don't break the streak
        if (currentStr == DateTime.now().dateOnly.toIso8601String()) {
          checkDate = checkDate.subtract(const Duration(days: 1));
          continue;
        }
        break; // Missed a day after the habit started
      }
      checkDate = checkDate.subtract(const Duration(days: 1));
    }
    return streak;
  }

  // --- WEEKLY LOGIC (e.g., 3x a week) ---
  static int _calculateWeekly(Habit habit, List<HabitLog> logs) {
    int streak = 0;
    DateTime now = DateTime.now().dateOnly;
    // Get Monday of the current week
    DateTime currentMonday = now.subtract(Duration(days: now.weekday - 1));

    bool isCurrentWeek = true;

    while (currentMonday.isAfter(
      habit.startDate.subtract(const Duration(days: 7)),
    )) {
      final weekStart = currentMonday;
      final weekEnd = currentMonday.add(const Duration(days: 7));

      final count = logs.where((l) {
        final d = DateTime.parse(l.completedAt);
        return (d.isAtSameMomentAs(weekStart) || d.isAfter(weekStart)) &&
            d.isBefore(weekEnd);
      }).length;

      if (count >= habit.habitRepetitionTimes) {
        streak++;
      } else if (!isCurrentWeek) {
        break; // Failed a past week
      }

      currentMonday = currentMonday.subtract(const Duration(days: 7));
      isCurrentWeek = false;
    }
    return streak;
  }

  // --- MONTHLY LOGIC ---
  static int _calculateMonthly(Habit habit, List<HabitLog> logs) {
    int streak = 0;
    DateTime now = DateTime.now().dateOnly;
    DateTime currentMonthStart = DateTime(now.year, now.month, 1);

    bool isCurrentMonth = true;

    while (currentMonthStart.isAfter(
      DateTime(habit.startDate.year, habit.startDate.month - 1, 1),
    )) {
      final nextMonth = DateTime(
        currentMonthStart.year,
        currentMonthStart.month + 1,
        1,
      );

      final count = logs.where((l) {
        final d = DateTime.parse(l.completedAt);
        return (d.isAtSameMomentAs(currentMonthStart) ||
                d.isAfter(currentMonthStart)) &&
            d.isBefore(nextMonth);
      }).length;

      if (count >= habit.habitRepetitionTimes) {
        streak++;
      } else if (!isCurrentMonth) {
        break;
      }

      currentMonthStart = DateTime(
        currentMonthStart.year,
        currentMonthStart.month - 1,
        1,
      );
      isCurrentMonth = false;
    }
    return streak;
  }
}

// Simple extension to make code cleaner
extension DateOnly on DateTime {
  DateTime get dateOnly => DateTime(year, month, day);
}
