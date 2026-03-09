import 'package:flutter/material.dart';

class Background extends StatefulWidget {
  final Widget child;
  const Background({super.key, required this.child});

  @override
  State<Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          CustomPaint(painter: BackgroundPainter(), child: Container()),
          widget.child,
        ],
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  @override
  void paintBackground(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.5),
        width: size.width,
        height: size.height,
      ),
      Paint()..color = Colors.blueAccent.withOpacity(0.1),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintBackground(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
