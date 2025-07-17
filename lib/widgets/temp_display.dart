import 'package:flutter/material.dart';

class TempDisplay extends StatelessWidget {
  final String label;
  final double temp;

  const TempDisplay({
    super.key,
    required this.label,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '${temp.toInt()}°',
          style: const TextStyle(
            fontSize: 80,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}