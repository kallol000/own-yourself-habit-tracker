import 'package:flutter/material.dart';

class NewHabitForm extends StatelessWidget {
  const NewHabitForm({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 200,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(2.0)),
        child: Column(
          
          children: [
            TextField(
              decoration: InputDecoration(border: OutlineInputBorder(), hintText: 'Habit'),
            )
          ],
        ),
      ),
    );
  }
}