import 'package:flutter/material.dart';
import 'package:own_yourself/utils/colors.dart';
import 'package:own_yourself/utils/types.dart';
import 'package:own_yourself/widgets/habit_card.dart';
import 'package:own_yourself/widgets/new_habit_form.dart';
import '../utils/data.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) {
        return NewHabitForm(submitAction: addNewHabit);
      },
    );
  }

  void addNewHabit(String habitName) {
    var newHabit = Habit(
      id: Uuid().v4(),
      title: habitName,
      repetitionType: HabitRepetitionType.daily,
      repetitionTimes: 1,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 30)),
    );

    setState(() {
      data.add(newHabit);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Own Yourself')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: createNewHabit,
        label: Text('Start a new Habit'),
        icon: Icon(Icons.add),
        backgroundColor: AppColors.backgroundColor,
        extendedTextStyle: TextStyle(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemBuilder: (context, index) {
            return HabitCard(title: data[index].title);
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 10);
          },
          itemCount: data.length,
        ),
      ),
    );
  }
}
