import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:own_yourself/database/app_database.dart';
import 'package:own_yourself/utils/consts.dart';
import 'package:own_yourself/utils/helper_functions.dart';
import 'package:own_yourself/utils/types.dart';
import 'package:own_yourself/widgets/habit_card.dart';
import 'package:own_yourself/widgets/new_habit_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AppDatabase db;

  @override
  void initState() {
    super.initState();
    db = AppDatabase();
  }

  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) {
        return NewHabitForm(submitAction: addNewHabit);
      },
    );
  }

  Future<void> addNewHabit(HabitEntity habit) async {
    await db.insertHabit(
      HabitsCompanion.insert(
        title: habit.title,
        habitRepetitionType: habit.repetitionType.name,
        habitRepetitionTimes: habit.repetitionTimes,
        startDate: DateTime.now(),
        endDate: Value(DateTime.now().add(Duration(days: 30))),
      ),
    );

    Navigator.pop(context);
  }

  Future<void> deleteExistingHabit(int id) async {
    await db.deleteHabit(id);
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
      body: StreamBuilder<List<HabitWithLogs>>(
        stream: db.watchHabitsWithLogs(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final habitsWithLogs = snapshot.data!;
          final fullData = habitsWithLogs
              .map(
                (item) => {
                  'habit': item.habit.toJson(),
                  'logs': item.logs.map((log) => log.toJson()).toList(),
                },
              )
              .toList();

          // print(fullData);

          if (habitsWithLogs.isEmpty) {
            getLastSevenDays();
            return const Center(child: Text("No habits yet"));
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              itemCount: habitsWithLogs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final habitWithLog = habitsWithLogs[index];
                return HabitCard(
                  title: habitWithLog.habit.title,
                  habitId: habitWithLog.habit.id,
                  deleteExistingHabit: deleteExistingHabit,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
