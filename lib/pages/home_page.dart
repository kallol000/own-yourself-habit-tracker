import 'package:flutter/material.dart';
import 'package:own_yourself/data/habit_database.dart';
import 'package:own_yourself/utils/consts.dart';
import 'package:own_yourself/utils/types.dart';
import 'package:own_yourself/widgets/habit_card.dart';
import 'package:own_yourself/widgets/new_habit_form.dart';
import '../utils/data.dart';

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

  Future<void> addNewHabit(Habit habit) async {
    var newHabit = Habit(
      // id: habit.id,
      title: habit.title,
      repetitionType: habit.repetitionType,
      repetitionTimes: habit.repetitionTimes,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 30)),
    );

    final id = await HabitDatabase.instance.insertHabit(habit);
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
      body: FutureBuilder(
        future: HabitDatabase.instance.getAllHabits(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final habits = snapshot.data as List<Habit>;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return HabitCard(title: habits[index].title);
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10);
                },
                itemCount: habits.length,
              ),
            );
          }
        },
      ),
      // body: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: ListView.separated(
      //     itemBuilder: (context, index) {
      //       return HabitCard(title: data[index].title);
      //     },
      //     separatorBuilder: (context, index) {
      //       return SizedBox(height: 10);
      //     },
      //     itemCount: data.length,
      //   ),
      // ),
    );
  }
}
