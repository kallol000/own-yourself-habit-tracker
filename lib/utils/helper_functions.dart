import 'package:own_yourself/utils/types.dart';

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
