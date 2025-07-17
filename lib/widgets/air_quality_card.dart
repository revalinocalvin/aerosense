import 'package:flutter/material.dart';

class AirQualityCard extends StatelessWidget {
  final double pm25;

  const AirQualityCard({super.key, required this.pm25});

  @override
  Widget build(BuildContext context) {
    String qualityText;
    double progress;
    if (pm25 <= 12) {
      qualityText = 'Good';
      progress = 0.8;
    } else if (pm25 <= 55) {
      qualityText = 'Moderate';
      progress = 0.5;
    } else {
      qualityText = 'Unhealthy';
      progress = 0.2;
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
              value: progress,
              minHeight: 12,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7ED321)),
              backgroundColor: Colors.white.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}