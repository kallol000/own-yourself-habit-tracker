import 'package:flutter/material.dart';
import 'package:own_yourself/utils/consts.dart';

class CardSegmentButton extends StatefulWidget {
  final List<String> days;
  // final int? selectedSegment;
  const CardSegmentButton({super.key, required this.days});

  @override
  State<CardSegmentButton> createState() => _CardSegmentButtonState();
}

class _CardSegmentButtonState extends State<CardSegmentButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SegmentedButton(
        style: SegmentedButton.styleFrom(
          backgroundColor: AppColors.surfaceColor,
          foregroundColor: AppColors.backgroundColor,
          selectedBackgroundColor: Colors.green,
          selectedForegroundColor: AppColors.surfaceColor,
          padding: EdgeInsets.all(0),
        ),
        showSelectedIcon: false,

        segments: widget.days
            .map((day) => ButtonSegment(value: day, label: Text(day)))
            .toList(),
        emptySelectionAllowed: true,
        selected: widget.days.where((day) => day == 'Mon').toSet(),
        onSelectionChanged: (Set<String> newSelection) {
          setState(() {
            Set<String> selectedDays = newSelection;
          });
        },
        multiSelectionEnabled: true,
      ),
    );
  }
}
