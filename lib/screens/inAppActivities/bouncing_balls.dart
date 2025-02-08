import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:async';

class BouncingBalls extends StatefulWidget {
  const BouncingBalls({Key? key}) : super(key: key);

  @override
  _BouncingBallsState createState() => _BouncingBallsState();
}

class _BouncingBallsState extends State<BouncingBalls> {
  final int totalBalls = 14;
  late List<Offset> ballPositions;
  late List<bool> ballVisibility;
  bool allBurst = false;
  final Random random = Random();
  Timer? positionTimer;

  @override
  void initState() {
    super.initState();
    ballVisibility = List.generate(totalBalls, (_) => true);

    // Update ball positions every second
    positionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!allBurst) {
        setState(() {
          ballPositions = List.generate(
              totalBalls,
              (_) => Offset(
                  random.nextDouble() * MediaQuery.of(context).size.width,
                  random.nextDouble() * MediaQuery.of(context).size.height));
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize ball positions here, as MediaQuery is now available
    ballPositions = List.generate(
        totalBalls,
        (_) => Offset(
            random.nextDouble() * MediaQuery.of(context).size.width,
            random.nextDouble() * MediaQuery.of(context).size.height));
  }

  @override
  void dispose() {
    positionTimer?.cancel();
    super.dispose();
  }

  void handleBurst(int index) {
    setState(() {
      ballVisibility[index] = false;
      if (ballVisibility.every((visible) => !visible)) {
        allBurst = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bouncing Balls"),
      ),
      body: Center(
        child: allBurst
            ? const Text(
                "Good job! You've turned your thoughts around! Now, more happiness is making its way to you!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.indigo),
              )
            : Stack(
                children: List.generate(totalBalls, (index) {
                  return Positioned(
                    left: ballPositions[index].dx,
                    top: ballPositions[index].dy,
                    child: ballVisibility[index]
                        ? GestureDetector(
                            onTap: () => handleBurst(index),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Colors.indigo,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  );
                }),
              ),
      ),
    );
  }
}