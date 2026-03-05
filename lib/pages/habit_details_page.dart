import 'package:flutter/material.dart';
import 'package:own_yourself/database/app_database.dart';
import 'package:table_calendar/table_calendar.dart';

class HabitDetailsPage extends StatefulWidget {
  final int habitId;
  const HabitDetailsPage({super.key, required this.habitId});

  @override
  State<HabitDetailsPage> createState() => _HabitDetailsPageState();
}

class _HabitDetailsPageState extends State<HabitDetailsPage> {
  late final AppDatabase db;

  Set<String> highlightedDays = {};

  @override
  void initState() {
    super.initState();
    db = AppDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: db.watchHabitWithLogsById(widget.habitId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(child: Text('No data found'));
          }

          final habitWithLogs = snapshot.data!;

          highlightedDays = habitWithLogs.logs
              .map((log) => DateTime.parse(log.completedAt).toIso8601String())
              .toSet();

          // print(habitWithLogs.habit.title);

          return Column(
            children: [
              Text(
                habitWithLogs.habit.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              BackButton(),
              TableCalendar(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: DateTime.now(),
                selectedDayPredicate: (day) {
                  // print(day);
                  return highlightedDays.contains(
                    DateTime(day.year, day.month, day.day).toIso8601String(),
                  );
                  // return true;
                },
                onDaySelected: (selectedDay, focusedDay) async {
                  final normalizedSelectedDay = DateTime(
                    selectedDay.year,
                    selectedDay.month,
                    selectedDay.day,
                  ).toIso8601String();
                  if (highlightedDays.contains(normalizedSelectedDay)) {
                    highlightedDays.remove(normalizedSelectedDay);
                  } else {
                    highlightedDays.add(normalizedSelectedDay);
                  }
                  await db.toggleHabitLog(widget.habitId, selectedDay);
                },
                calendarBuilders: CalendarBuilders(
                  // This custom builder only runs for specific days
                  defaultBuilder: (context, day, focusedDay) {
                    final normalized = DateTime(
                      day.year,
                      day.month,
                      day.day,
                    ).toIso8601String();
                    if (highlightedDays.contains(normalized)) {
                      return Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.green, // Your habit completion color
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${day.day}',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return null; // Use default styling for non-completed days
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
