import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart'; // Import Realtime Database
import 'package:flutter/services.dart';
import 'screens/sensor_data_page.dart';
import 'services/notification_service.dart'; // Your notification service from the previous step

// A global instance of the notification service
final NotificationService _notificationService = NotificationService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize the notification service
  await _notificationService.init();

  // Set up a listener for Realtime Database changes
  setupDataListener();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));

  runApp(const AeroSenseApp());
}

void setupDataListener() {
  // Define the path to your data in the Realtime Database
  DatabaseReference sensorRef =
  FirebaseDatabase.instance.ref('AirMonitor');

  // Listen for changes at that database path
  sensorRef.onValue.listen((DatabaseEvent event) {
    final data = event.snapshot.value;
    if (data != null) {
      // The data from RTDB is often a Map<dynamic, dynamic>
      final sensorData = Map<String, dynamic>.from(data as Map);

      if (sensorData.containsKey('PM25')) {
        final double pm25 = (sensorData['PM25'] as num).toDouble();

        // Check if the air quality is unhealthy
        if (pm25 > 55) {
          _notificationService.showNotification(
            'Unhealthy Air Quality Alert',
            'The PM2.5 level is currently ${pm25.toStringAsFixed(1)}. Please take precautions.',
          );
        }
      }
    }
  });
}

class AeroSenseApp extends StatelessWidget {
  const AeroSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AeroSense',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'oneUI',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const SensorDataPage(),
    );
  }
}