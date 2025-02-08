import 'dart:async';
import 'package:flutter/material.dart';

class RippleEffect extends StatefulWidget {
  const RippleEffect({Key? key}) : super(key: key);

  @override
  _RippleEffectState createState() => _RippleEffectState();
}

class _RippleEffectState extends State<RippleEffect> {
  final List<Offset> ripples = [];
  final List<double> rippleSizes = [];
  Timer? rippleTimer;

  @override
  void initState() {
    super.initState();

    // Start a timer to update ripple sizes periodically
    rippleTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      updateRippleSizes();
    });
  }

  @override
  void dispose() {
    rippleTimer?.cancel();
    super.dispose();
  }

  void addRipple(Offset position) {
    setState(() {
      ripples.add(position);
      rippleSizes.add(0); // Start the ripple size at 0
    });
  }

  void updateRippleSizes() {
    setState(() {
      for (int i = 0; i < rippleSizes.length; i++) {
        rippleSizes[i] += 2; // Increment ripple size to make it expand

        // Remove ripple if it becomes too large
        if (rippleSizes[i] > 200) {
          ripples.removeAt(i);
          rippleSizes.removeAt(i);
          break; // Prevent out-of-bounds errors
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ripple Effect"),
      ),
      body: GestureDetector(
        onTapDown: (details) {
          addRipple(details.localPosition);
        },
        child: CustomPaint(
          painter: RipplePainter(ripples, rippleSizes),
          child: Container(),
        ),
      ),
    );
  }
}

class RipplePainter extends CustomPainter {
  final List<Offset> ripples;
  final List<double> rippleSizes;

  RipplePainter(this.ripples, this.rippleSizes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (int i = 0; i < ripples.length; i++) {
      canvas.drawCircle(ripples[i], rippleSizes[i], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}