import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:own_yourself/utils/consts.dart';
import 'package:own_yourself/utils/helper_functions.dart';
import 'package:own_yourself/utils/types.dart';
import 'package:uuid/uuid.dart';

class NewHabitForm extends StatefulWidget {
  Future<void> Function(Habit) submitAction;
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
        width: 400,
        height: 400,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(0.0)),
        
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("I want to...", style: TextStyle(fontSize: 16)),
            TextField(
              style: TextStyle(color: AppColors.backgroundColor),

              controller: habitNameController,
              decoration: InputDecoration(hintText: 'Excercise'),
            ),

            Row(
              spacing: 10,
              children: [
                if (selectedRepetitionType != 0)
                  CupertinoButton(
                    child: Text((selectedRepetitionTimes + 1).toString()),

                    onPressed: () {
                      return showRepetitionTimesPicker(
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
                          children: habitTimeOptions(
                            HabitRepetitionType.values[selectedRepetitionType],
                          ).map((e) => Text(e.toString())).toList(),
                        ),
                      );
                    },
                  ),
                if (selectedRepetitionType != 0)
                  Text('time(s)', style: TextStyle(fontSize: 16)),
                CupertinoButton(
                  child: Text(
                    habitRepetitionTypeNames.values
                        .elementAt(selectedRepetitionType)
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

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  var newHabit = Habit(
                    id: Uuid().v4(),
                    title: habitNameController.text,
                    repetitionType:
                        HabitRepetitionType.values[selectedRepetitionType],
                    startDate: DateTime.now(),
                    endDate: DateTime(2099),
                  );
                  // widget.submitAction(newHabit);
                },
                child: Text('Start'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
