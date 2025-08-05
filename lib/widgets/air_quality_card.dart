import 'package:flutter/material.dart';
import 'dart:ui'; // Import dart:ui to use lerpDouble

class AirQualityCard extends StatelessWidget {
  final double score;
  final String category;

  const AirQualityCard({
    super.key,
    required this.score,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    // --- NEW LOGIC ---
    // 1. Determine the progress bar color based on the category
    final Color dangerousColor = Colors.red;
    final Color unhealthyColor = Colors.orange;
    final Color moderateColor = Colors.yellow;
    final Color goodColor = Colors.green;
    final Color idealColor = const Color(0xFF7ED321); // We can still use const here for a specific hex value
    final Color breathtakingColor = Colors.cyan.shade300; // This is the line that caused the error

    // 2. This function will hold our final, calculated color
    Color progressiveColor;

    // 3. Determine the color by blending between checkpoints based on the score
    if (score < 30) {
      // It's in the 'Dangerous' range (0-30). Blend from Red up to Orange.
      final t = score / 30.0; // How far are we from 0 to 30?
      progressiveColor = Color.lerp(dangerousColor, unhealthyColor, t)!;

    } else if (score < 60) {
      // It's in the 'Unhealthy' range (30-60). Blend from Orange up to Yellow.
      final t = (score - 30) / (60 - 30); // How far are we from 30 to 60?
      progressiveColor = Color.lerp(unhealthyColor, moderateColor, t)!;

    } else if (score < 70) {
      // It's in the 'Moderate' range (60-70). Blend from Yellow up to Green.
      final t = (score - 60) / (70 - 60);
      progressiveColor = Color.lerp(moderateColor, goodColor, t)!;

    } else if (score < 80) {
      // It's in the 'Good' range (70-80). Blend from Green up to Ideal.
      final t = (score - 70) / (80 - 70);
      progressiveColor = Color.lerp(goodColor, idealColor, t)!;

    } else if (score < 95) {
      // It's in the 'Ideal' range (80-90). Blend from Ideal up to Breathtaking.
      final t = (score - 80) / (95 - 80);
      progressiveColor = Color.lerp(idealColor, breathtakingColor, t)!;

    } else {
      // It's in the 'Breathtaking' range (90-100), just show the solid top color.
      progressiveColor = breathtakingColor;
    }

    // 2. The progress bar value is now directly from the score
    final double progressValue = score / 100.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1053A1),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Air Quality', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.normal, fontSize: 16)),
          const SizedBox(height: 4),

          // The main text now displays the dynamic category
          Text(
            category,
            style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),

          // The progress bar now uses our new variables
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: 12,
              valueColor: AlwaysStoppedAnimation<Color>(progressiveColor),
              backgroundColor: Colors.white.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}