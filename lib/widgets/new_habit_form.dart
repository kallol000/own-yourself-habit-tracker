import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:own_yourself/utils/consts.dart';
import 'package:own_yourself/utils/helper_functions.dart';
import 'package:own_yourself/utils/types.dart';

class NewHabitForm extends StatefulWidget {
  final Future<void> Function(HabitEntity) submitAction;
  const NewHabitForm({super.key, required this.submitAction});

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

  @override
  void initState() {
    super.initState();
    // This forces the widget to rebuild as you type,
    // enabling the "Start" button color logic
    habitNameController.addListener(_onTextChanged);
  }

  void _onTextChanged() => setState(() {});

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
          color: AppColors.backgroundColor,
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
          color: AppColors.backgroundColor,
          // Use a SafeArea widget to avoid system overlaps.
          child: SafeArea(top: false, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentTextStyle: TextStyle(color: AppColors.surfaceColor),

      content: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: AppColors.backgroundColor.withAlpha(500),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 40,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,

            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: []),
              Text(
                "I want to..",
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.surfaceColor.withAlpha(150),
                ),
              ),
              TextField(
                style: TextStyle(
                  color: AppColors.surfaceColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),

                controller: habitNameController,

                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    gapPadding: 0.0,
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.surfaceColor.withAlpha(50),
                  hintText: 'e.g. Excercise',
                  hintStyle: TextStyle(
                    color: AppColors.surfaceColor.withAlpha(100),
                  ),
                ),
              ),

              Row(
                spacing: 10,
                children: [
                  if (selectedRepetitionType != 0)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.surfaceColor.withAlpha(50),
                      ),
                      child: CupertinoButton(
                        child: Text(
                          (selectedRepetitionTimes + 1).toString(),
                          style: TextStyle(
                            color: AppColors.surfaceColor.withAlpha(200),
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        onPressed: () {
                          return showRepetitionTimesPicker(
                            CupertinoPicker(
                              backgroundColor: Colors.transparent,
                              scrollController: FixedExtentScrollController(
                                initialItem: selectedRepetitionTimes,
                              ),
                              itemExtent: 32,
                              onSelectedItemChanged: (value) {
                                setState(() {
                                  selectedRepetitionTimes = value;
                                });
                              },
                              children:
                                  habitTimeOptions(
                                        HabitRepetitionType
                                            .values[selectedRepetitionType],
                                      )
                                      .map(
                                        (e) => Text(
                                          e.toString(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                      .toList(),
                            ),
                          );
                        },
                      ),
                    ),
                  if (selectedRepetitionType != 0)
                    Text('time(s)', style: TextStyle(fontSize: 16)),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.surfaceColor.withAlpha(50),
                    ),
                    child: CupertinoButton(
                      child: Text(
                        habitRepetitionTypeNames.values
                            .elementAt(selectedRepetitionType)
                            .toString()
                            .split('.')
                            .last,
                        style: TextStyle(
                          color: AppColors.surfaceColor.withAlpha(200),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      onPressed: () {
                        return showRepetitionTypePicker(
                          CupertinoPicker(
                            backgroundColor: Colors.transparent,

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
                                .map(
                                  (e) => Text(
                                    e.toString().split('.').last,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                                .toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              Container(
                alignment: Alignment.topRight,

                child: SizedBox(
                  // width: double.infinity,
                  height: 50,
                  child: !habitNameController.text.trim().isEmpty
                      ? FilledButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              habitNameController.text.trim().isEmpty
                                  ? AppColors.surfaceColor
                                  : AppColors.accentColor.withAlpha(200),
                            ),
                            textStyle: WidgetStateProperty.all(
                              TextStyle(
                                color: AppColors.surfaceColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (habitNameController.text.trim().isEmpty) return;
                            var newHabit = HabitEntity(
                              // id: Uuid().v4(),
                              title: habitNameController.text,
                              repetitionType: HabitRepetitionType
                                  .values[selectedRepetitionType],
                              repetitionTimes: selectedRepetitionType == 0
                                  ? 1
                                  : selectedRepetitionTimes + 1,
                              startDate: DateTime.now(),
                              endDate: DateTime(2099),
                            );
                            widget.submitAction(newHabit);
                          },
                          child: Text('Start'),
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
