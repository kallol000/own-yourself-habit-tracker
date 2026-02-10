import 'package:flutter/material.dart';
import 'package:own_yourself/utils/colors.dart';
import 'package:own_yourself/widgets/habit_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Own Yourself')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Start a new Habit'),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.accentColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(spacing: 10, children: [Habit(), Habit(), Habit()]),
      ),
    );
  }
}
