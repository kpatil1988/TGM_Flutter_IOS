import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class FloatingFeathers extends StatefulWidget {
  const FloatingFeathers({Key? key}) : super(key: key);

  @override
  _FloatingFeathersState createState() => _FloatingFeathersState();
}

class _FloatingFeathersState extends State<FloatingFeathers> {
  final Random random = Random();
  final List<Offset> featherPositions = [];
  Timer? featherTimer;

  @override
  void initState() {
    super.initState();

    // Start the timer to move feathers
    featherTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      moveFeathers();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize feather positions here, as MediaQuery is now available
    generateFeathers();
  }

  void generateFeathers() {
    featherPositions.clear();
    for (int i = 0; i < 10; i++) {
      featherPositions.add(Offset(
        random.nextDouble() * MediaQuery.of(context).size.width,
        random.nextDouble() * MediaQuery.of(context).size.height,
      ));
    }
  }

  void moveFeathers() {
    setState(() {
      for (int i = 0; i < featherPositions.length; i++) {
        // Move the feather downward
        featherPositions[i] = Offset(
          featherPositions[i].dx,
          featherPositions[i].dy + 5, // Adjust speed here
        );

        // Reset the feather's position if it goes off the screen
        if (featherPositions[i].dy > MediaQuery.of(context).size.height) {
          featherPositions[i] = Offset(
            random.nextDouble() * MediaQuery.of(context).size.width,
            0, // Reset to the top of the screen
          );
        }
      }
    });
  }

  void catchFeather(int index) {
    setState(() {
      featherPositions.removeAt(index);
    });
  }

  @override
  void dispose() {
    featherTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Floating Feathers"),
      ),
      body: Stack(
        children: List.generate(featherPositions.length, (index) {
          return Positioned(
            left: featherPositions[index].dx,
            top: featherPositions[index].dy,
            child: GestureDetector(
              onTap: () => catchFeather(index),
              child: Icon(
                Icons.bubble_chart,
                color: Colors.blueAccent,
                size: 30,
              ),
            ),
          );
        }),
      ),
    );
  }
}