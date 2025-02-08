import 'dart:math';
import 'package:flutter/material.dart';

class VirtualBubbleWrap extends StatefulWidget {
  const VirtualBubbleWrap({Key? key}) : super(key: key);

  @override
  _VirtualBubbleWrapState createState() => _VirtualBubbleWrapState();
}

class _VirtualBubbleWrapState extends State<VirtualBubbleWrap> {
  final int gridSize = 5; // 5x5 grid
  late List<bool> bubbles; // Tracks whether each bubble is popped
  bool allPopped = false;

  @override
  void initState() {
    super.initState();
    bubbles = List.generate(gridSize * gridSize, (_) => true); // All bubbles start unpopped
  }

  void popBubble(int index) {
    setState(() {
      bubbles[index] = false; // Mark bubble as popped
      if (bubbles.every((bubble) => !bubble)) {
        allPopped = true; // Check if all bubbles are popped
      }
    });
  }

  void resetGame() {
    setState(() {
      bubbles = List.generate(gridSize * gridSize, (_) => true); // Reset all bubbles
      allPopped = false;
    });
  }

  Color getRandomPastelColor() {
    final random = Random();
    final r = random.nextInt(127) + 128; // Random value between 128-255
    final g = random.nextInt(127) + 128;
    final b = random.nextInt(127) + 128;
    return Color.fromARGB(255, r, g, b);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Virtual Bubble Wrap"),
      ),
      body: Center(
        child: allPopped
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Congratulations! You've awakened the child within you successfully!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.indigo),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: resetGame,
                    child: const Text("Reset Bubbles"),
                  ),
                ],
              )
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize, // Number of bubbles in a row
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: gridSize * gridSize,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => popBubble(index), // Pop bubble on tap
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: bubbles[index] ? 1.0 : 0.0, // Hide popped bubbles
                      child: Container(
                        decoration: BoxDecoration(
                          color: bubbles[index] ? getRandomPastelColor() : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}