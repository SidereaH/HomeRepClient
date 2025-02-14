import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedMenuButton extends StatefulWidget {
  final VoidCallback? onTap;

  const AnimatedMenuButton({super.key, this.onTap});

  @override
  _AnimatedMenuButtonState createState() => _AnimatedMenuButtonState();
}

class _AnimatedMenuButtonState extends State<AnimatedMenuButton>
    with SingleTickerProviderStateMixin {
  bool isOpen = false;
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _translationAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    final curve = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(curve);
    _rotationAnimation = Tween<double>(begin: 0.0, end: math.pi / 4).animate(curve);
    _translationAnimation = Tween<double>(begin: 0.0, end: 8.0).animate(curve);
  }

  void _toggleMenu() {
    setState(() {
      isOpen = !isOpen;
      isOpen ? _controller.forward() : _controller.reverse();
      widget.onTap?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleMenu,
      child: Container(
        width: 29,
        height: 29,
        decoration: BoxDecoration(
          color: Color(0xFF009EDC), // Background color
          borderRadius: BorderRadius.circular(2), // Corner radius
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Upper line (long line)
                  Positioned(
                    left: 4.08334,  // x position from SVG
                    top: 4.77783 + _translationAnimation.value, // Apply translation for animation
                    child: Transform.rotate(
                      angle: _rotationAnimation.value,
                      child: _buildLine(20.83), // Top line from SVG
                    ),
                  ),
                  // Middle line (shorter line)
                  Positioned(
                    left: 4.08334,  // x position from SVG
                    top: 12.5557,   // y position from SVG
                    child: Opacity(
                      opacity: _opacityAnimation.value,
                      child: _buildLine(14.77), // Middle line from SVG
                    ),
                  ),
                  // Lower line (long line)
                  Positioned(
                    left: 4.08334,  // x position from SVG
                    top: 20.3334 - _translationAnimation.value, // Apply translation for animation
                    child: Transform.rotate(
                      angle: -_rotationAnimation.value,
                      child: _buildLine(20.83), // Bottom line from SVG
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLine(double width) {
    return Container(
      width: width,
      height: 3.88, // Height from SVG
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(1.944), // Rounded corners from SVG
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
