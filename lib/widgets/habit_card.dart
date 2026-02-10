import 'package:flutter/material.dart';
import 'package:own_yourself/utils/colors.dart';

class Habit extends StatelessWidget {
  const Habit({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      tileColor: AppColors.accentColor,
      textColor: AppColors.surfaceColor,
      title: Row(
        spacing: 10.0,
        children: [
          Icon(Icons.fitness_center, color: AppColors.surfaceColor),
          Text(
            "Exercise",
            style: TextStyle(
              color: AppColors.surfaceColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      subtitle: Row(
        spacing: 12.0,
        children: [
          Text("Mon", style: TextStyle(color: AppColors.surfaceColor)),
          Text("Tue", style: TextStyle(color: AppColors.surfaceColor)),
          Text("Wed", style: TextStyle(color: AppColors.surfaceColor)),
          Text("Thu", style: TextStyle(color: AppColors.surfaceColor)),
          Text("Fri", style: TextStyle(color: AppColors.surfaceColor)),
          Icon(Icons.check, color: AppColors.surfaceColor),
          Text("Sun", style: TextStyle(color: AppColors.surfaceColor)),
        ],
      ),

      // subtitle: Text('¬Habit Description'),
      // trailing: Icon(Icons.check_circle_outline),
    );
  }
}
