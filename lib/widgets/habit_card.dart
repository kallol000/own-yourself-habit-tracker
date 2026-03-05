import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:own_yourself/database/app_database.dart';
import 'package:own_yourself/utils/consts.dart';
import 'package:own_yourself/utils/helper_functions.dart';
import 'package:own_yourself/widgets/card_segment_button.dart';
import 'package:own_yourself/widgets/confirmation_popup.dart';

class HabitCard extends StatefulWidget {
  final int habitId;
  final String title;
  final Future<void> Function(int id) deleteExistingHabit;
  final Future<void> Function(int habitId, DateTime date) toggleHabitLog;
  final List<HabitLog> habitLogs;
  const HabitCard({
    super.key,
    required this.title,
    required this.deleteExistingHabit,
    required this.habitId,
    required this.toggleHabitLog,
    required this.habitLogs,
  });

  @override
  State<HabitCard> createState() => _HabitCardState();
}

final List<String> lastSevenDays = getLastNDays(7);

final List<DateTime> lastSevenWeekdays = getLastNWeekdays(7);

class _HabitCardState extends State<HabitCard> {
  void deleteHabit(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return ConfirmationPopup(
          id: widget.habitId,
          deleteExistingHabit: widget.deleteExistingHabit,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: deleteHabit,
            backgroundColor: AppColors.errorColor,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        tileColor: AppColors.backgroundColor,

        title: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            spacing: 10.0,
            children: [
              Icon(Icons.fitness_center, color: AppColors.surfaceColor),
              Text(
                widget.title,
                style: TextStyle(
                  color: AppColors.surfaceColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        subtitle: Row(
          spacing: 12.0,
          children: [
            CardSegmentButton(
              habitId: widget.habitId,
              days: lastSevenWeekdays,
              toggleHabitLog: widget.toggleHabitLog,
              habitLogs: widget.habitLogs,
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     getLastNDays(10);
            //   },
            //   child: Text('data'),
            // ),
          ],
        ),

        // subtitle: Text('¬Habit Description'),
        // trailing: Icon(Icons.check_circle_outline),
      ),
    );
  }
}
