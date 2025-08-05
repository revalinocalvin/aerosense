// lib/models/air_quality_index.dart

class AirQualityIndex {
  // This will hold the final score, e.g., 70.65
  final double score;

  // This will hold the final category name, e.g., "Good", "Unhealthy"
  final String category;

  // This is the constructor. It requires a score and a category
  // every time we create an instance of this class.
  AirQualityIndex({
    required this.score,
    required this.category,
  });
}