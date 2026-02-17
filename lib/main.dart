import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:own_yourself/pages/home_page.dart';
import 'package:own_yourself/utils/consts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.surfaceColor,
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(globalRadius),
          ),
        ),
        dialogTheme: DialogThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(globalRadius),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            foregroundColor: AppColors.surfaceColor,
            backgroundColor: AppColors.backgroundColor,
          ),
        ),
        cupertinoOverrideTheme: CupertinoThemeData(
          barBackgroundColor: AppColors.backgroundColor,
          primaryColor: AppColors.backgroundColor,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
