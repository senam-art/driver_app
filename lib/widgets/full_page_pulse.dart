import 'package:flutter/material.dart';

class FullPagePulseAnimation extends StatefulWidget {
  const FullPagePulseAnimation({super.key});

  @override
  State<FullPagePulseAnimation> createState() => _FullPagePulseAnimationState();
}

class _FullPagePulseAnimationState extends State<FullPagePulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      // Slower duration gives a deliberate, "wave" feel
      duration: const Duration(milliseconds: 2500), 
    )..repeat(); // This keeps the animation looping
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We'll use multiple concentric rings. 
    // This is achieved by stacking and animating multiple containers.

    // Calculate maximum needed radius.
    final size = MediaQuery.of(context).size;
    // We make the radius slightly larger than the screen's diagonal for total coverage.
    final maxRadius = (size.width > size.height ? size.width : size.height) * 1.1;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double value = _controller.value;

        // The overall pulse effect is a semi-transparent, fading red overlay.
        return Container(
          // Fade the whole background from red to white
          color: const Color(0xFFC62828).withOpacity((1.0 - value) * 0.1),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Concentric Ring 1 (Inner)
              _buildRing(
                  radius: maxRadius * 0.4 * value,
                  opacity: 1.0 - value, // Gets clearer as it expands
                  startOffset: 0.1),
              // Concentric Ring 2 (Middle) with time offset
              _buildRing(
                  radius: maxRadius * 0.8 * value,
                  opacity: value > 0.4 ? 1.0 - (value - 0.4) / 0.6 : 1.0, 
                  startOffset: 0.5),
              // Concentric Ring 3 (Outer) with more time offset
              _buildRing(
                  radius: maxRadius * 1.2 * value,
                  opacity: value > 0.8 ? 1.0 - (value - 0.8) / 0.2 : 1.0,
                  startOffset: 0.9),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRing({required double radius, required double opacity, required double startOffset}) {
    // The ring is a Container with a circular shape and border.
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // The ring itself gets more transparent as it reaches the edges
        border: Border.all(
          // Fading color with a minimum opacity so it doesn't vanish entirely before expansion
          color: const Color(0xFFC62828).withOpacity(opacity * (0.2 + startOffset * 0.7)),
          width: 2.0 + (startOffset * 4), // The ring gets slightly thicker as it expands
        ),
      ),
    );
  }
}