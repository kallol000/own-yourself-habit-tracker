import 'dart:ui';
import 'package:flutter/material.dart';

class ShaderGradientWidget extends StatefulWidget {
  final Color colorA;
  final Color colorB;

  const ShaderGradientWidget({
    super.key, 
    this.colorA = Colors.blue, 
    this.colorB = Colors.orange,
  });

  @override
  State<ShaderGradientWidget> createState() => _ShaderGradientWidgetState();
}

class _ShaderGradientWidgetState extends State<ShaderGradientWidget>
    with SingleTickerProviderStateMixin {
  FragmentShader? shader;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _loadShader();
    // A longer duration (10-15s) usually makes the mesh look more "fluid"
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  void _loadShader() async {
    // Ensure the asset path matches your pubspec.yaml exactly
    final program = await FragmentProgram.fromAsset(
      'assets/shaders/gradient.frag',
    );
    setState(() {
      shader = program.fragmentShader();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (shader == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: MeshPainter(
            shader: shader!,
            time: _controller.value * 6.28, // Sends 0 to 2*PI for smooth cycles
            colorA: widget.colorA,
            colorB: widget.colorB,
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

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
    // Slot mapping must match your .frag file order!
    // [0,1] = uSize (vec2)
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    
    // [2] = uTime (float)
    shader.setFloat(2, time);

    // [3,4,5] = uColorA (vec3)
    shader.setFloat(3, colorA.red / 255.0);
    shader.setFloat(4, colorA.green / 255.0);
    shader.setFloat(5, colorA.blue / 255.0);

    // [6,7,8] = uColorB (vec3)
    shader.setFloat(6, colorB.red / 255.0);
    shader.setFloat(7, colorB.green / 255.0);
    shader.setFloat(8, colorB.blue / 255.0);

    final paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(MeshPainter oldDelegate) {
    return oldDelegate.time != time ||
        oldDelegate.colorA != colorA ||
        oldDelegate.colorB != colorB;
  }
}