import 'dart:math' as math;
import 'package:flutter/material.dart';

class PulsatingNfcIcon extends StatefulWidget {
  const PulsatingNfcIcon({super.key});

  @override
  State<PulsatingNfcIcon> createState() => _PulsatingNfcIconState();
}

class _PulsatingNfcIconState extends State<PulsatingNfcIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1500, // Faster, constant 1.5s loop
      ),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 450,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // The CustomPainter layered behind, drawing the radiating arcs
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: _RadiatingArcsPainter(
                    animationValue: _controller.value,
                    // The radius of our core circle below so the arcs know exactly where to start
                    coreRadius: 75.0,
                    // The vertical offset of the core circle's center from the bottom
                    coreCenterYOffset: 75.0,
                  ),
                );
              },
            ),
          ),

          // The central core icon
          Positioned(
            bottom: 0,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                double corePulse = (0.5 - (0.5 - _controller.value).abs()) * 2.0;
                return Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(
                      0xFFC62828,
                    ).withValues(alpha: 0.05 + (0.15 * Curves.easeInOut.transform(corePulse))),
                  ),
                  child: const Center(child: Icon(Icons.nfc, size: 70, color: Color(0xFFC62828))),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RadiatingArcsPainter extends CustomPainter {
  final double animationValue;
  final double coreRadius;
  final double coreCenterYOffset;

  _RadiatingArcsPainter({
    required this.animationValue,
    required this.coreRadius,
    required this.coreCenterYOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Center point of the core NFC icon
    final Offset coreCenter = Offset(size.width / 2, size.height - coreCenterYOffset);

    // We'll draw 3 radiating arcs that spread upwards at the EXACT SAME TIME
    // The delay parametrizes how far along the radius they are structurally, but they animate
    // synchronized to the same progress cycle (animationValue).
    _drawArcGroup(canvas, coreCenter, animationValue);
  }

  void _drawArcGroup(Canvas canvas, Offset center, double progress) {
    // We draw 3 arcs that move together in unison, separated slightly by starting radius
    _drawSingleEmanatingArc(canvas, center, progress, 0.0);
    _drawSingleEmanatingArc(canvas, center, progress, 50.0); // 50 pixels further out
    _drawSingleEmanatingArc(canvas, center, progress, 100.0); // 100 pixels further out
  }

  void _drawSingleEmanatingArc(Canvas canvas, Offset center, double progress, double radiusOffset) {
    // Linear continuous expansion without easeOut slowing down at the end
    final double expansion = progress;

    // The radius starts at the edge of the core icon (plus any arbitrary structural offset) and expands
    // Adjusted spread distance slightly
    final double radius = coreRadius + radiusOffset + (expansion * 120.0);

    // Fade in quickly, then fade out continuously as it moves rather than holding
    double opacity = 0.0;
    if (progress < 0.15) {
      // Fast fade in
      opacity = (progress / 0.15) * 0.8;
    } else {
      // Linear smooth fade out for the remaining 85% of movement
      opacity = (1.0 - ((progress - 0.15) / 0.85)) * 0.8;
    }

    final Paint paint = Paint()
      ..color = const Color(0xFFC62828).withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth =
          3.0 +
          (progress * 2.0) // Lines get slightly thicker as they expand
      ..strokeCap = StrokeCap.round; // Soften the edges of the arc

    // Draw an arc.
    // - Math.pi (180 degrees) starts at the left side
    // - sweepAngle defines how much of the circle to draw. We'll draw slightly less than a full semi-circle (e.g., 120 degrees arc)
    // - We want it centered on the top, so we span from roughly -150 degrees to -30 degrees
    // An arc spanning 60 degrees centrally focused upwards
    double sweepAngle = math.pi / 3; // 60 degrees
    double startAngle =
        math.pi + (math.pi - sweepAngle) / 2; // Centers the arc symmetrically at the top

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false, // useCenter = false (true makes a filled pie slice)
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _RadiatingArcsPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
