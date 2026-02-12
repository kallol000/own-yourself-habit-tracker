import 'package:flutter/material.dart';

class NewHabitForm extends StatefulWidget {
  void Function(String) submitAction;
  NewHabitForm({super.key, required this.submitAction});

  @override
  State<NewHabitForm> createState() => _NewHabitFormState();
}

class _NewHabitFormState extends State<NewHabitForm> {
  TextEditingController habitNameController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 200,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(2.0)),
        child: Column(
          
          children: [
            TextField(
              controller: habitNameController,
              decoration: InputDecoration(border: OutlineInputBorder(), hintText: 'Habit'),
            ),
            MaterialButton(onPressed: () {
              widget.submitAction(habitNameController.text);
            },child: Text('Submit'),)
          ],
        ),
      ),
    );
  }
}