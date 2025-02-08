import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class AffirmationCatcher extends StatefulWidget {
  const AffirmationCatcher({Key? key}) : super(key: key);

  @override
  _AffirmationCatcherState createState() => _AffirmationCatcherState();
}

class _AffirmationCatcherState extends State<AffirmationCatcher> {
  final List<String> affirmations = [
    "You are loved.",
    "You are enough.",
    "You are strong.",
    "You are valued.",
    "You are worthy.",
    "Well-being abounds.",
    "The universe is on my side.",
    "I'm love personified.",
    "I got this!",
    "You Got This!",
    "It's going to be okay.",
    "You can figure this out.",
    "I'm capable."
  ];

  List<Map<String, dynamic>> fallingAffirmations = [];
  double basketX = 0;
  double basketWidth = 100;
  double basketHeight = 20;
  bool showMessage = false;
  late Timer affirmationTimer;
  late Timer movementTimer;

  @override
  void initState() {
    super.initState();

    // Delay MediaQuery access until after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenWidth = MediaQuery.of(context).size.width;

      // Set initial basket position
      setState(() {
        basketX = screenWidth / 2 - basketWidth / 2;
      });

      // Add a new affirmation every 2 seconds
      affirmationTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
        final random = Random();
        final text = affirmations[random.nextInt(affirmations.length)];
        final width = text.length * 10.0 + 40.0;
        final newX = random.nextDouble() * (screenWidth - width);

        setState(() {
          fallingAffirmations.add({
            'id': DateTime.now().millisecondsSinceEpoch,
            'text': text,
            'x': newX,
            'y': 0.0,
            'width': width,
          });
        });
      });

      // Move affirmations down the screen
      movementTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
        setState(() {
          fallingAffirmations = fallingAffirmations
              .map((affirmation) {
                affirmation['y'] += 5.0;
                return affirmation;
              })
              .where((affirmation) =>
                  affirmation['y'] < MediaQuery.of(context).size.height)
              .toList();
        });

        checkCollisions();
      });

      // Show the message after 1 minute
      Future.delayed(const Duration(minutes: 1), () {
        setState(() {
          showMessage = true;
        });
      });
    });
  }

  @override
  void dispose() {
    affirmationTimer.cancel();
    movementTimer.cancel();
    super.dispose();
  }

  void checkCollisions() {
    final basketRect = Rect.fromLTWH(
      basketX,
      MediaQuery.of(context).size.height - basketHeight - 10,
      basketWidth,
      basketHeight,
    );

    setState(() {
      fallingAffirmations = fallingAffirmations.where((affirmation) {
        final affirmationRect = Rect.fromLTWH(
          affirmation['x'],
          affirmation['y'],
          affirmation['width'],
          30.0,
        );

        return !basketRect.overlaps(affirmationRect);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Affirmation Catcher"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            basketX += details.delta.dx;
            basketX = basketX.clamp(0.0, MediaQuery.of(context).size.width - basketWidth);
          });
        },
        child: Stack(
          children: [
            // Falling affirmations
            ...fallingAffirmations.map((affirmation) {
              return Positioned(
                left: affirmation['x'],
                top: affirmation['y'],
                child: Container(
                  width: affirmation['width'],
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    affirmation['text'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),

            // Basket
            Positioned(
              bottom: 10.0,
              left: basketX,
              child: Container(
                width: basketWidth,
                height: basketHeight,
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),

            // Message Box
            if (showMessage)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Container(
                    width: 300,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Amazing!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'You’re catching positivity with ease. Trust yourself, you\'re capable of anything!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}