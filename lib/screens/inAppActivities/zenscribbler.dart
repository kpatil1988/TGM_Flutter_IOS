import 'dart:ui';
import 'package:flutter/material.dart';

class ZenScribbler extends StatefulWidget {
  const ZenScribbler({Key? key}) : super(key: key);

  @override
  _ZenScribblerState createState() => _ZenScribblerState();
}

class _ZenScribblerState extends State<ZenScribbler> {
  final GlobalKey _canvasKey = GlobalKey();
  final List<Offset> _points = []; // Stores the points for drawing
  bool showReflectionInput = false; // Controls the visibility of the reflection input
  final TextEditingController _reflectionController = TextEditingController();
  String? upliftingMessage;

  void startReflection() {
    setState(() {
      showReflectionInput = true;
    });
  }

  void submitReflection() {
    if (_reflectionController.text.trim().isEmpty) {
      setState(() {
        upliftingMessage = "Please reflect on your thoughts. You are doing great!";
      });
    } else {
      setState(() {
        upliftingMessage = "Thank you for sharing! Remember, you are loved and cherished. 💖";
        _reflectionController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Zen Scribbler"),
      ),
      body: Stack(
        children: [
          // Canvas for drawing
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                final RenderBox renderBox = _canvasKey.currentContext?.findRenderObject() as RenderBox;
                _points.add(renderBox.globalToLocal(details.globalPosition));
              });
            },
            onPanEnd: (details) {
              setState(() {
                _points.add(Offset.zero); // Add a placeholder to indicate a break in the drawing
              });

              // Start reflection input after 10 seconds
              Future.delayed(const Duration(seconds: 10), () {
                if (!showReflectionInput) {
                  startReflection();
                }
              });
            },
            child: RepaintBoundary(
              key: _canvasKey,
              child: CustomPaint(
                painter: ScribblePainter(_points),
                size: Size.infinite,
              ),
            ),
          ),

          // Reflection input
          if (showReflectionInput)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Reflect on your feelings:",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _reflectionController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Type your thoughts here...",
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: submitReflection,
                          child: const Text("Submit Reflection"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Uplifting message
          if (upliftingMessage != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  upliftingMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, color: Colors.indigo),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ScribblePainter extends CustomPainter {
  final List<Offset> points;

  ScribblePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.indigo
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}