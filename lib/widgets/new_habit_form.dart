import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:own_yourself/utils/colors.dart';
import 'package:own_yourself/utils/types.dart';

class NewHabitForm extends StatefulWidget {
  void Function(String) submitAction;
  NewHabitForm({super.key, required this.submitAction});

  @override
  State<NewHabitForm> createState() => _NewHabitFormState();
}

class _NewHabitFormState extends State<NewHabitForm> {
  TextEditingController habitNameController = TextEditingController();
  TextEditingController repetitionTypeController = TextEditingController();
  TextEditingController repetitionTimesController = TextEditingController();
  bool showRepetitionTimes = false;
  int selectedRepetitionType = 0;
  int selectedRepetitionTimes = 0;

  void showRepetitionTypePicker(Widget child) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          // The Bottom margin is provided to align the popup above the system navigation bar.
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // Provide a background color for the popup.
          color: CupertinoColors.systemBackground.resolveFrom(context),
          // Use a SafeArea widget to avoid system overlaps.
          child: SafeArea(top: false, child: child),
        );
      },
    );
  }

  void showRepetitionTimesPicker(Widget child) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          // The Bottom margin is provided to align the popup above the system navigation bar.
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // Provide a background color for the popup.
          color: CupertinoColors.systemBackground.resolveFrom(context),
          // Use a SafeArea widget to avoid system overlaps.
          child: SafeArea(top: false, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: 500,
        height: 500,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(2.0)),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("I want to...", style: TextStyle(fontSize: 16)),
            TextField(
              style: TextStyle(color: AppColors.backgroundColor),

              controller: habitNameController,
              decoration: InputDecoration(hintText: 'Habit'),
            ),

            Row(
              children: [
                CupertinoButton(
                  child: Text(
                    HabitRepetitionTimes[selectedRepetitionTimes]
                        .toString()
                        .split('.')
                        .last,
                  ),

                  onPressed: () {
                    return showRepetitionTypePicker(
                      CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: selectedRepetitionTimes,
                        ),
                        itemExtent: 32,
                        onSelectedItemChanged: (value) {
                          setState(() {
                            selectedRepetitionTimes = value;
                          });
                        },
                        children: [...HabitRepetitionTimes]
                            .map((e) => Text(e.toString().split('.').last))
                            .toList(),
                      ),
                    );
                  },
                ),
                Text('time(s)', style: TextStyle(fontSize: 16)),
                CupertinoButton(
                  child: Text(
                    HabitRepetitionType.values[selectedRepetitionType]
                        .toString()
                        .split('.')
                        .last,
                  ),

                  onPressed: () {
                    return showRepetitionTypePicker(
                      CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: selectedRepetitionType,
                        ),
                        itemExtent: 32,
                        onSelectedItemChanged: (value) {
                          setState(() {
                            selectedRepetitionType = value;
                          });
                        },
                        children: [...HabitRepetitionType.values]
                            .map((e) => Text(e.toString().split('.').last))
                            .toList(),
                      ),
                    );
                  },
                ),
              ],
            ),

            FilledButton(
              onPressed: () {
                widget.submitAction(habitNameController.text);
              },
              child: Text('Start'),
            ),
          ],
        ),
      ),
    );
  }
}
