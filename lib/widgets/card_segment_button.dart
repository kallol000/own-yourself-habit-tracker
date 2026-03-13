import 'package:flutter/material.dart';
import 'package:own_yourself/database/app_database.dart';
import 'package:own_yourself/utils/consts.dart';
import 'package:own_yourself/utils/helper_functions.dart';

class CardSegmentButton extends StatefulWidget {
  final int habitId;
  final List<DateTime> days;
  final List<Weekday>? weekdays;
  final Future<void> Function(int habitId, DateTime date)? toggleHabitLog;
  final List<HabitLog> habitLogs;
  // final int? selectedSegment;
  const CardSegmentButton({
    super.key,
    required this.habitId,
    required this.days,
    this.weekdays,
    required this.toggleHabitLog,
    required this.habitLogs,
  });

  @override
  State<CardSegmentButton> createState() => _CardSegmentButtonState();
}

class _CardSegmentButtonState extends State<CardSegmentButton> {
  @override
  @override
  Widget build(BuildContext context) {
    final Set<String> loggedDates = widget.habitLogs
        .map((log) => log.completedAt)
        .toSet();

    final List<bool> currentSelection = widget.days.map((day) {
      final String normalizedDay = DateTime(
        day.year,
        day.month,
        day.day,
      ).toIso8601String();
      return loggedDates.contains(normalizedDay);
    }).toList();

    return Expanded(
      child: ToggleButtons(
        fillColor: AppColors.surfaceColor.withAlpha(50),
        selectedColor: AppColors.accentColor,
        borderRadius: BorderRadius.circular(5),

        splashColor: Colors.white.withAlpha(50),
        textStyle: TextStyle(color: AppColors.surfaceColor, fontSize: 12),

        // disabledColor: AppColors.surfaceColor,
        color: AppColors.surfaceColor,
        constraints: BoxConstraints(minHeight: 30, minWidth: 40),
        isSelected: currentSelection,
        children: widget.days
            .map(
              (day) => Container(
                child: Text(
                  weekdayMap[day.weekday]!,
                  style: TextStyle(
                    // color: AppColors.surfaceColor,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            )
            .toList(),
        onPressed: (index) {
          widget.toggleHabitLog!(widget.habitId, widget.days[index]);
          // print(weekdaysLogged);
        },
      ),
    );
  }
}
