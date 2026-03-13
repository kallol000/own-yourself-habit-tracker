import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:own_yourself/database/app_database.dart';
import 'package:own_yourself/utils/consts.dart';
import 'package:own_yourself/utils/helper_functions.dart';
import 'package:own_yourself/utils/types.dart';
import 'package:own_yourself/widgets/background.dart';
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
    final normalizedDate = DateTime(2026, 2, 1);

    await db.insertHabit(
      HabitsCompanion.insert(
        title: habit.title,
        habitRepetitionType: habit.repetitionType.name,
        habitRepetitionTimes: habit.repetitionTimes,
        startDate: normalizedDate,
      ),
    );

    Navigator.pop(context);
  }

  // This is called when user swipes  left to delete a habit card
  Future<void> deleteExistingHabit(int id) async {
    await db.deleteHabit(id);
  }

  // This is called when user clicks the day for a habit on a specific day
  Future<void> toggleHabitLog(int habitId, DateTime date) async {
    final updatedData = await db.getHabitWithLogsById(habitId);

    final newStreak = StreakCalculator.calculate(
      updatedData.habit,
      updatedData.logs,
    );

    await db.updateCurrentStreak(habitId, newStreak);

    await db.toggleHabitLog(habitId, date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Container(child: Text("Mindful Habits")),

        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontFamily: GoogleFonts.nunito().fontFamily,
          color: AppColors.surfaceColor,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.surfaceColor.withAlpha(50),
        onPressed: createNewHabit,
        child: Icon(Icons.add, color: AppColors.surfaceColor),
        // label: Text('Start a new Habit'),
        // icon: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: db.watchHabitsWithLast7DaysLogs(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text("Error: ${snapshot.error}"));
          }

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

          print(fullData);

          if (habitsWithLogs.isEmpty) {
            // getLastSevenDays();
            return const Center(child: Text("No habits yet"));
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              itemCount: habitsWithLogs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final habitWithLogs = habitsWithLogs[index];
                return HabitCard(
                  title: habitWithLogs.habit.title,
                  habitId: habitWithLogs.habit.id,
                  deleteExistingHabit: deleteExistingHabit,
                  toggleHabitLog: toggleHabitLog,
                  habitLogs: habitWithLogs.logs,
                  currentStreak: habitWithLogs.habit.currentStreak,
                  habitRepetitionType: habitWithLogs.habit.habitRepetitionType,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
