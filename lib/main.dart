import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'screens/sensor_data_page.dart';
import 'services/notification_service.dart';

// 1. DEFINE THE STATES FOR OUR NOTIFICATION LOGIC
enum AirQualityNotificationState {
  safe,
  unhealthy,
}

// 2. CREATE A VARIABLE TO HOLD THE CURRENT STATE
// We start by assuming the air is safe.
AirQualityNotificationState _notificationState = AirQualityNotificationState.safe;

final NotificationService _notificationService = NotificationService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await _notificationService.init();

  // Set up the listener with the new, improved logic
  setupDataListener();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));

  runApp(const AeroSenseApp());
}

// 3. UPDATE THE LISTENER WITH STATEFUL LOGIC
void setupDataListener() {
  DatabaseReference sensorRef = FirebaseDatabase.instance.ref('AirMonitor');

  sensorRef.onValue.listen((DatabaseEvent event) {
    final data = event.snapshot.value;
    if (data != null) {
      final sensorData = Map<String, dynamic>.from(data as Map);

      if (sensorData.containsKey('PM25')) {
        final double pm25 = (sensorData['PM25'] as num).toDouble();

        // Step A: Determine the current state based on the new data.
        final currentState = (pm25 > 55)
            ? AirQualityNotificationState.unhealthy
            : AirQualityNotificationState.safe;

        // Step B: Check if the state has CHANGED from safe to unhealthy.
        if (currentState == AirQualityNotificationState.unhealthy &&
            _notificationState == AirQualityNotificationState.safe) {
          // This block now only runs ONCE when the threshold is first crossed.
          _notificationService.showNotification(
            'Unhealthy Air Quality Alert',
            'The PM2.5 level is currently ${pm25.toStringAsFixed(1)}. Please take precautions.',
          );
        }

        // Step C: ALWAYS update the state variable to remember the current state for next time.
        _notificationState = currentState;
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