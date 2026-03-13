import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:own_yourself/database/app_database.dart';
import 'package:own_yourself/utils/consts.dart';
import 'package:own_yourself/utils/helper_functions.dart';
import 'package:own_yourself/utils/types.dart';
import 'package:own_yourself/widgets/card_segment_button.dart';
import 'package:own_yourself/widgets/confirmation_popup.dart';
import 'package:own_yourself/pages/habit_details_page.dart';
import 'package:gradient_borders/gradient_borders.dart';

class HabitCard extends StatefulWidget {
  final int habitId;
  final String title;
  final int currentStreak;
  final String habitRepetitionType;
  final Future<void> Function(int id) deleteExistingHabit;
  final Future<void> Function(int habitId, DateTime date) toggleHabitLog;
  final List<HabitLog> habitLogs;

  const HabitCard({
    super.key,
    required this.title,
    required this.deleteExistingHabit,
    required this.habitId,
    required this.currentStreak,
    required this.toggleHabitLog,
    required this.habitLogs,
    required this.habitRepetitionType,
  });

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard>
    with SingleTickerProviderStateMixin {
  FragmentShader? shader;
  late AnimationController _controller;

  final List<DateTime> lastSevenWeekdays = getLastNWeekdays(7);

  @override
  void initState() {
    super.initState();
    _loadShader();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  void _loadShader() async {
    try {
      final program = await FragmentProgram.fromAsset(
        'assets/shaders/gradient.frag',
      );
      setState(() {
        shader = program.fragmentShader();
      });
    } catch (e) {
      print("SHADER ERROR: $e"); // This will tell you if the file path is wrong
    }
  }

  void deleteHabit(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationPopup(
        id: widget.habitId,
        deleteExistingHabit: widget.deleteExistingHabit,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.title);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),

        child: Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: deleteHabit,
                backgroundColor: AppColors.errorColor,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HabitDetailsPage(
                  habitId: widget.habitId,
                  habitTitle: widget.title,
                ),
              ),
            ),
            child: Stack(
              children: [
                if (shader != null)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.surfaceColor.withAlpha(20),
                      ),
                    ),
                  ),

                // 3. CONTENT
                ListTile(
                  tileColor: Colors.transparent,
                  contentPadding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 4,
                    // vertical: 4,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 0.0),
                    child: Column(
                      children: [
                        Row(
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: 10,
                          children: [
                            Icon(
                              Icons.class_rounded,
                              size: 20,
                              color: AppColors.surfaceColor,
                            ),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    '${widget.currentStreak} ${widget.habitRepetitionType == 'daily'
                                        ? 'day'
                                        : widget.habitRepetitionType == 'weekly'
                                        ? 'week'
                                        : 'month'} streak', // TODO: Calculate this dynamically
                                    style: TextStyle(
                                      color: AppColors.surfaceColor.withAlpha(
                                        150,
                                      ),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(children: [
                            
                          ],
                        ),
                        // SizedBox(height: 10),
                      ],
                    ),
                  ),
                  subtitle: CardSegmentButton(
                    habitId: widget.habitId,
                    days: lastSevenWeekdays,
                    toggleHabitLog: widget.toggleHabitLog,
                    habitLogs: widget.habitLogs,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// UPDATED PAINTER WITH DYNAMIC COLORS
class MeshPainter extends CustomPainter {
  final FragmentShader shader;
  final double time;
  final Color colorA;
  final Color colorB;

  MeshPainter({
    required this.shader,
    required this.time,
    required this.colorA,
    required this.colorB,
  });

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, time);

    // Color A
    shader.setFloat(3, colorA.red / 255.0);
    shader.setFloat(4, colorA.green / 255.0);
    shader.setFloat(5, colorA.blue / 255.0);

    // Color B
    shader.setFloat(6, colorB.red / 255.0);
    shader.setFloat(7, colorB.green / 255.0);
    shader.setFloat(8, colorB.blue / 255.0);

    final paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(MeshPainter oldDelegate) =>
      oldDelegate.time != time ||
      oldDelegate.colorA != colorA ||
      oldDelegate.colorB != colorB;
}
