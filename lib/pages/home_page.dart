import 'package:flutter/material.dart';
import 'package:own_yourself/utils/colors.dart';
import 'package:own_yourself/widgets/habit_card.dart';
import 'package:own_yourself/widgets/new_habit_form.dart';
import '../utils/data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void createNewHabit(){
    showDialog(context: context, builder: (context){
      return NewHabitForm();
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Own Yourself')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: createNewHabit,
        label: Text('Start a new Habit'),
        icon:  Icon(Icons.add),
        backgroundColor: AppColors.accentColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(itemBuilder: (context, index) {
          return Habit(title: data[index]);
        },itemCount: data.length,),
      ),
    );
  }
}
