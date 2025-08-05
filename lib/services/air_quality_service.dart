// lib/services/air_quality_service.dart

import 'dart:math'; // We need this for the max() function
import '../models/air_quality_index.dart'; // Import our new model

class AirQualityService {

  // This is the main public function that the rest of our app will use.
  AirQualityIndex calculate(
      {required double pm, required double gas, required double humidity}) {

    // --- Part 1: Calculate Penalties based on your formulas ---

    // P_PM = 0.43 × max(0, PM - 35)
    final double pmPenalty = 0.43 * max(0, pm - 35);

    // NEW: P_Gas = 0.05 × max(0, Gas - 500)
    final double gasPenalty = 0.05 * max(0, gas - 500);

    // P_Hum = 1 x deviasi kelembapan dari 40–60
    // NEW: P_Hum = 0.25 x deviasi kelembapan dari 40–60
    double humidityPenalty;
    if (humidity < 40) {
      humidityPenalty = (40 - humidity) * 0.25;
    } else if (humidity > 60) {
      humidityPenalty = (humidity - 60) * 0.25;
    } else {
      humidityPenalty = 0;
    }
    // The formula says 1 point per % deviation, so the penalty is the deviation itself.

    // Total Penalti = P_PM + P_Gas + P_Hum
    final double totalPenalty = pmPenalty + gasPenalty + humidityPenalty;


    // --- Part 2: Calculate Final Score ---

    // Skor Akhir = 100 - Total Penalti
    // We use .clamp() to ensure the score never goes above 100 or below 0.
    final double finalScore = (100 - totalPenalty).clamp(0, 100);


    // --- Part 3: Determine Category based on the new thresholds ---

    String category;
    if (finalScore >= 90) { // Your doc says 100-90, but >=90 is simpler
      category = "Breathtaking";
    } else if (finalScore >= 80) { // 80-89
      category = "Ideal";
    } else if (finalScore >= 70) { // 70-79
      category = "Good";
    } else if (finalScore >= 60) { // 60-69
      category = "Moderate";
    } else if (finalScore >= 30) { // 30-59
      category = "Unhealthy";
    } else { // 0-29
      category = "Dangerous";
    }

    // --- Part 4: Return the final results in our clean data model ---
    return AirQualityIndex(score: finalScore, category: category);
  }
}