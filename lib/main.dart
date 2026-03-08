import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import 'package:own_yourself/pages/home_page.dart';
import 'package:own_yourself/widgets/shader_gradient.dart'; // Ensure this points to your widget

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // The 'builder' wraps the Navigator, keeping the background persistent
      builder: (context, child) {
        return Scaffold(
          body: Stack(
            children: [
              // 1. The Animated Shader (Persistent across all pages)
              const Positioned.fill(
                child: ShaderGradientWidget(
                  colorA: Color(0xFF000000), // Deep Blue
                  colorB: Color(0xFF14213D),
                ),
              ),

              // 2. A subtle Glassmorphism overlay
              // This blurs the background slightly and adds a tint for readability
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(color: Colors.black.withOpacity(0.3)),
                ),
              ),

              // 3. The actual App content (Navigator)
              if (child != null) child,
            ],
          ),
        );
      },
      home: const HomePage(),
    );
  }
}
