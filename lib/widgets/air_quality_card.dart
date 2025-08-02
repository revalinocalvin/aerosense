import 'package:flutter/material.dart';
import 'dart:ui'; // Import dart:ui to use lerpDouble

class AirQualityCard extends StatelessWidget {
  final double pm25;

  const AirQualityCard({super.key, required this.pm25});

  // Helper function to get the progressive color
  Color _getProgressiveColor() {
    // 1. Define our color checkpoints
    const Color goodColor = Color(0xFF7ED321);
    const Color moderateColor = Colors.yellow;
    const Color unhealthyColor = Colors.red;

    // 2. Handle the different ranges
    if (pm25 <= 12.0) {
      return goodColor; // Solid green for "Good"
    } else if (pm25 <= 55.0) {
      // It's between "Good" and "Moderate". Let's blend the colors.
      // We need to calculate how far we are into this range (from 12 to 55).
      // This formula converts our pm25 value into a 0.0 to 1.0 scale.
      final double t = (pm25 - 12.0) / (55.0 - 12.0);

      // lerp will return null if one of the colors is null, so we use '!' to assert it won't happen.
      return Color.lerp(goodColor, moderateColor, t)!;
    } else if (pm25 <= 100.0) { // Let's set a realistic upper unhealthy bound
      // It's between "Moderate" and "Unhealthy". Let's blend.
      final double t = (pm25 - 55.0) / (100.0 - 55.0);
      return Color.lerp(moderateColor, unhealthyColor, t)!;
    } else {
      // If it's off the charts, just show solid red
      return unhealthyColor;
    }
  }

  // Helper function to get the progress value for the bar
  double _getProgressValue() {
    // This scales the pm25 value to a 0.0 to 1.0 range.
    // We'll cap it at 150 for the visual maximum.
    final double scaledValue = (lerpDouble(0, 1, pm25 / 100) ?? 0).clamp(0.0, 1.0);

    // *** THIS IS THE FIX ***
    // We invert the value so that a low pm25 (good air) results in a high
    // progress value (a full bar), and a high pm25 (bad air) results
    // in a low progress value (an empty bar).
    return 1.0 - scaledValue;
  }


  @override
  Widget build(BuildContext context) {
    String qualityText;
    // Keep this logic for the text label
    if (pm25 <= 12) {
      qualityText = 'Good';
    } else if (pm25 <= 55) {
      qualityText = 'Moderate';
    } else {
      qualityText = 'Unhealthy';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1053A1),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Air Quality', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.normal, fontSize: 16)),
          const SizedBox(height: 4),
          Text(
            qualityText,
            style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              // Use our new helper functions here
              value: _getProgressValue(),
              minHeight: 12,
              valueColor: AlwaysStoppedAnimation<Color>(_getProgressiveColor()),
              backgroundColor: Colors.white.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}