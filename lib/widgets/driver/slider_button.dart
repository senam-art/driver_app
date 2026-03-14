import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ActionSlider extends StatefulWidget {
  final VoidCallback onAction;
  final String sliderText;

  const ActionSlider({super.key, this.sliderText = "Slide to Act", required this.onAction});

  @override
  State<ActionSlider> createState() => ActionSliderState();
}

class ActionSliderState extends State<ActionSlider> {
  double _dragPosition = 0;
  final double _buttonSize = 50;
  bool _isDragging = false;

  // CALL THIS FROM YOUR PARENT ON ERROR
  void reset() {
    setState(() {
      _dragPosition = 0;
      _isDragging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        double maxTravel = maxWidth - _buttonSize - 10;

        return Container(
          width: maxWidth,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F4F8),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Stack(
            children: [
              Center(
                child: Opacity(
                  opacity: (1.0 - (_dragPosition / maxTravel)).clamp(0.0, 1.0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.redAccent.withValues(alpha: 0.4),
                    highlightColor: Colors.redAccent,
                    child: Text(
                      widget.sliderText,
                      style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: _isDragging ? Duration.zero : const Duration(milliseconds: 300),
                curve: Curves.bounceOut, // Added a nice bounce effect for the reset
                left: _dragPosition,
                child: GestureDetector(
                  onHorizontalDragStart: (_) => setState(() => _isDragging = true),
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _dragPosition += details.delta.dx;
                      if (_dragPosition < 0) _dragPosition = 0;
                      if (_dragPosition > maxTravel) _dragPosition = maxTravel;
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    setState(() {
                      _isDragging = false;
                      if (_dragPosition > maxWidth * 0.8) {
                        _dragPosition = maxTravel;
                        widget.onAction(); // Trigger the Supabase call
                      } else {
                        _dragPosition = 0;
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    width: _buttonSize,
                    height: _buttonSize,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10),
                      ],
                    ),
                    child: const Icon(Icons.double_arrow_rounded, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
