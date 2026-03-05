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
  final List<bool> weekdaysSelected = List.generate(7, (index) => false);
  Set<String> weekdaysLogged = new Set();

  @override
  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < widget.habitLogs.length; i++) {
      String logDate = widget.habitLogs[i].completedAt;
      weekdaysLogged.add(logDate);
    }

    for (int i = 6; i >= 0; i--) {
      DateTime today = DateTime.now();
      final midnightToday = DateTime(today.year, today.month, today.day);
      String specificDay = midnightToday
          .subtract(Duration(days: 6 - i))
          .toIso8601String();
      if (weekdaysLogged.contains(specificDay)) {
        weekdaysSelected[i] = true;
      }
    }

    return Expanded(
      child: ToggleButtons(
        fillColor: AppColors.accentColor,
        selectedColor: AppColors.surfaceColor,
        borderWidth: 1,
        color: AppColors.surfaceColor,
        constraints: BoxConstraints(minHeight: 30, minWidth: 40),

        isSelected: weekdaysSelected,
        children: widget.days
            .map((day) => Text(weekdayMap[day.weekday]!))
            .toList(),
        onPressed: (index) {
          widget.toggleHabitLog!(widget.habitId, widget.days[index]);
          print(weekdaysLogged);
          setState(() {
            // weekdaysSelected[index] = !weekdaysSelected[index];
          });
        },
      ),
      // child: SegmentedButton(
      //   style: SegmentedButton.styleFrom(
      //     backgroundColor: AppColors.surfaceColor,
      //     foregroundColor: AppColors.backgroundColor,
      //     selectedBackgroundColor: Colors.green,
      //     selectedForegroundColor: AppColors.surfaceColor,
      //     padding: EdgeInsets.all(0),
      //   ),
      //   showSelectedIcon: false,

      //   segments: widget.days
      //       .map(
      //         (day) => ButtonSegment(
      //           value: day,
      //           label: Text(
      //             weekdayMap[day.weekday]!,
      //           ), // Use short name for display
      //         ),
      //       )
      //       .toList(),
      //   emptySelectionAllowed: true,
      //   selected: widget.days.toSet(),
      //   onSelectionChanged: (Set<DateTime> newSelection) {
      //     widget.toggleHabitLog!(widget.habitId, DateTime.now());
      //     setState(() {
      //       print(newSelection);
      //       Set<DateTime> selectedDays = newSelection;
      //     });
      //   },
      //   multiSelectionEnabled: true,
      // ),
    );
  }
}
