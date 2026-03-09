import 'package:flutter/material.dart';
import 'package:own_yourself/database/app_database.dart';
import 'package:own_yourself/utils/consts.dart';
import 'package:own_yourself/utils/helper_functions.dart';
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
      backgroundColor: Colors.transparent,

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
          print(habitWithLogs.habit.habitRepetitionTimes);

          highlightedDays = habitWithLogs.logs
              .map((log) => DateTime.parse(log.completedAt).toIso8601String())
              .toSet();

          // print(habitWithLogs.habit.title);

          final streak = StreakCalculator.calculate(
            habitWithLogs.habit,
            habitWithLogs.logs,
          );

          // print('Current Streak: $streak');

          return Padding(
            padding: const EdgeInsets.all(16.0),

            child: Column(
              spacing: 16,
              children: [
                Row(
                  children: [
                    Text(
                      habitWithLogs.habit.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 24,
                        color: AppColors.surfaceColor,
                      ),
                    ),
                    SizedBox(height: 20),
                    BackButton(),
                  ],
                ),
                Row(
                  spacing: 16,
                  children: [
                    Expanded(
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceColor.withAlpha(20),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Current Streak",
                              style: TextStyle(
                                color: AppColors.surfaceColor.withAlpha(100),
                              ),
                            ),
                            Text(
                              "$streak",
                              style: TextStyle(
                                color: AppColors.accentColor,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceColor.withAlpha(20),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "best Streak",
                              style: TextStyle(
                                color: AppColors.surfaceColor.withAlpha(100),
                              ),
                            ),
                            Text(
                              "${habitWithLogs.habit.bestStreak}",
                              style: TextStyle(
                                color: AppColors.accentColor,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TableCalendar(
                    headerStyle: HeaderStyle(
                      titleTextStyle: TextStyle(
                        color: AppColors.surfaceColor,
                        fontSize: 18,
                        // fontWeight: FontWeight.bold,
                      ),
                      formatButtonVisible: false,
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: AppColors.surfaceColor,
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: AppColors.surfaceColor,
                      ),
                    ),
                    calendarStyle: CalendarStyle(
                      defaultTextStyle: TextStyle(
                        color: AppColors.surfaceColor.withAlpha(200),
                      ),
                      weekendTextStyle: TextStyle(
                        color: AppColors.surfaceColor.withAlpha(200),
                      ),
                      outsideTextStyle: TextStyle(
                        color: AppColors.surfaceColor.withAlpha(100),
                      ),
                      selectedDecoration: BoxDecoration(
                        color: AppColors.accentColor,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: AppColors.accentColor.withAlpha(100),
                        shape: BoxShape.circle,
                      ),
                    ),
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: DateTime.now(),
                    selectedDayPredicate: (day) {
                      // print(day);
                      return highlightedDays.contains(
                        DateTime(
                          day.year,
                          day.month,
                          day.day,
                        ).toIso8601String(),
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

                      // 3. BEST STREAK LOGIC
                      // Get the most recent data for this specific habit
                      final updatedData = await db.getHabitWithLogsById(
                        widget.habitId,
                      );

                      final newStreak = StreakCalculator.calculate(
                        updatedData.habit,
                        updatedData.logs,
                      );

                      // Only update if the new streak is higher than the previous best
                      if (newStreak > updatedData.habit.bestStreak) {
                        await db.updateBestStreak(widget.habitId, newStreak);
                      }
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
                              color:
                                  Colors.green, // Your habit completion color
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
