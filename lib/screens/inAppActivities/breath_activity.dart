import 'dart:async';
import 'package:flutter/material.dart';

class Breathe extends StatefulWidget {
  const Breathe({Key? key}) : super(key: key);

  @override
  _BreatheState createState() => _BreatheState();
}

class _BreatheState extends State<Breathe> {
  String breathing = "Breathe Out";
  int timer = 120;
  bool isComplete = false;
  Timer? timerCountdown;
  Timer? breathingCycle;

  @override
  void initState() {
    super.initState();

    // Start countdown timer
    timerCountdown = Timer.periodic(const Duration(seconds: 1), (_) {
      if (timer > 0) {
        setState(() {
          timer--;
        });
      } else {
        setState(() {
          isComplete = true;
        });
        timerCountdown?.cancel();
      }
    });

    // Start breathing cycle
    breathingCycle = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!isComplete) {
        setState(() {
          breathing = breathing == "Breathe In" ? "Breathe Out" : "Breathe In";
        });
      }
    });
  }

  @override
  void dispose() {
    timerCountdown?.cancel();
    breathingCycle?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Breathe"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isComplete ? "Nice!" : breathing,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            AnimatedContainer(
              duration: const Duration(seconds: 5),
              width: breathing == "Breathe In" ? 150 : 100,
              height: breathing == "Breathe In" ? 150 : 100,
              decoration: const BoxDecoration(
                color: Colors.yellow,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isComplete
                  ? "Go with the flow!"
                  : "Time Left: ${timer ~/ 60}:${(timer % 60).toString().padLeft(2, '0')}",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}