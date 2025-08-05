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
    Color progressBarColor;
    switch (category) {
      case "Breathtaking":
      case "Ideal":
        progressBarColor = Colors.cyan.shade300; // A nice, crisp blue/green
        break;
      case "Good":
        progressBarColor = Colors.green;
        break;
      case "Moderate":
        progressBarColor = Colors.yellow;
        break;
      case "Unhealthy":
        progressBarColor = Colors.orange;
        break;
      case "Dangerous":
        progressBarColor = Colors.red;
        break;
      default:
        progressBarColor = Colors.grey;
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
              valueColor: AlwaysStoppedAnimation<Color>(progressBarColor),
              backgroundColor: Colors.white.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}