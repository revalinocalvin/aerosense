// lib/services/outsidetemp_service.dart

import 'dart:convert'; // Required to decode the JSON response from the API
import 'package:geolocator/geolocator.dart'; // For getting GPS location
import 'package:http/http.dart' as http; // For making the web request
import '../models/outsidetemp_model.dart'; // Import our custom model

class OutsideTempService {
  // Base URL for the WeatherAPI endpoint
  static const _baseUrl = 'https://api.weatherapi.com/v1/current.json';

  // Your secret API key.
  // It's better practice to store this more securely, but for now, this works.
  final String _apiKey;

  // The constructor requires the API key when an instance of the service is created.
  OutsideTempService(this._apiKey);


  // This is the main public function that our UI will call.
  // It returns a 'Future' because it's an asynchronous operation.
  Future<OutsideTemp> getOutsideTempByCurrentLocation() async {

    // --- Part 1: Handle Location Permissions ---
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // If permission hasn't been granted yet, we request it from the user.
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // If the user explicitly denies the permission, we can't proceed.
        // We throw an error that our UI can catch and display a message.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // If the user has permanently denied permissions, we also can't proceed.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }


    // --- Part 2: Get the Phone's Actual GPS Coordinates ---
    // If we have permission, we can now get the location.
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high, // We want a fairly accurate location
    );


    // --- Part 3: Call the WeatherAPI ---
    // Construct the full URL with the API key and the coordinates.
    final url = '$_baseUrl?key=$_apiKey&q=${position.latitude},${position.longitude}';

    // Use the http package to make the web request.
    final response = await http.get(Uri.parse(url));


    // --- Part 4: Parse the Response ---
    if (response.statusCode == 200) {
      // A status code of 200 means the request was successful.
      // We decode the JSON string from the response body.
      final decodedJson = json.decode(response.body);

      // Create an instance of our OutsideTemp model using the data.
      final outsideTemp = OutsideTemp(
        cityName: decodedJson['location']['name'],
        temperature: decodedJson['current']['temp_c'].toDouble(),
      );

      // Return the final, clean data object.
      return outsideTemp;

    } else {
      // If the server did not return a 200 OK response, something went wrong.
      return Future.error('Failed to load weather data. Status: ${response.statusCode}');
    }
  }
}