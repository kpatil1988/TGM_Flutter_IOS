import 'dart:async';
import 'package:flutter/material.dart';

class TimerGame extends StatefulWidget {
  const TimerGame({Key? key}) : super(key: key);

  @override
  _TimerGameState createState() => _TimerGameState();
}

class _TimerGameState extends State<TimerGame> {
  final TextEditingController _controller = TextEditingController();
  int? targetNumber; // The number input by the user
  double timerValue = 0; // Current timer value (changed to double for fractional updates)
  Timer? _timer; // Timer instance
  String message = ""; // Message to show to the user
  bool showSuccessAnimation = false; // To show success animation
  double progress = 0; // Progress bar value

  void startTimer() {
    setState(() {
      timerValue = 0;
      progress = 0;
      message = ""; // Clear any previous message
      showSuccessAnimation = false; // Reset animation
    });

    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        timerValue += 1; // Increment timer value by 0.1 seconds
        progress = timerValue / ((targetNumber ?? 0) + 15); // Update progress bar
      });

      // Stop the timer automatically after targetNumber + 15 seconds
      if (timerValue >= (targetNumber ?? 0) + 15) {
        timer.cancel();
        setState(() {
          message = "Try Again! Timer restarted.";
        });
        startTimer(); // Restart the timer
      }
    });
  }

  void stopTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel(); // Stop the timer
      if (timerValue.toInt() == targetNumber) {
        setState(() {
          message = "🎉 Congratulations! You stopped the timer at the correct time! 🎉";
          showSuccessAnimation = true; // Trigger success animation
        });
      } else {
        setState(() {
          message = "❌ Try Again! Timer restarted.";
        });
        startTimer(); // Restart the timer
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Clean up the timer
    _controller.dispose(); // Dispose of the text controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Timer Game"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade200, Colors.deepPurple.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Enter a number between 120 and 180:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Enter your number",
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final input = int.tryParse(_controller.text);
                  if (input != null && input >= 120 && input <= 180) {
                    setState(() {
                      targetNumber = input;
                    });
                    startTimer();
                  } else {
                    setState(() {
                      message = "⚠️ Please enter a valid number between 120 and 180.";
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade700,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Start Timer",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                  ),
                  Text(
                    "${timerValue.toStringAsFixed(1)}s",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: stopTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Stop Timer",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              AnimatedOpacity(
                opacity: showSuccessAnimation ? 1.0 : 0.0,
                duration: const Duration(seconds: 1),
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: showSuccessAnimation ? Colors.greenAccent : Colors.redAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
