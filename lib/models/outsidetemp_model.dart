// lib/models/outsidetemp_model.dart

class OutsideTemp {
  final String cityName;
  final double temperature;

  // This is the constructor for the class.
  // It requires that a city name and a temperature are provided when creating an instance.
  OutsideTemp({
    required this.cityName,
    required this.temperature,
  });
}