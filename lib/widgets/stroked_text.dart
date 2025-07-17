import 'package:flutter/material.dart';

class StrokedText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final double strokeWidth;
  final Color strokeColor;

  const StrokedText({
    super.key,
    required this.text,
    required this.style,
    this.strokeWidth = 1,
    this.strokeColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Stroked text in the background
        Text(
          text,
          style: style.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor.withOpacity(0.7), // Use opacity for a softer look
          ),
        ),
        // Filled text on top
        Text(text, style: style),
      ],
    );
  }
}