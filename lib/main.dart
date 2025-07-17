import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'screens/sensor_data_page.dart'; // Import the new screen file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // *** FIX 1: Enable Edge-to-Edge display ***
  // This tells the system that our app can draw behind the system bars.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // *** FIX 2: Make the system bars transparent ***
  // This makes the navigation bar see-through, so our gradient is visible.
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Status bar (top)
    systemNavigationBarColor: Colors.transparent, // Navigation bar (bottom)
    systemNavigationBarDividerColor: Colors.transparent,
  ));

  runApp(const AeroSenseApp());
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
        // *** FIX: Set the default font family for the entire app ***
        fontFamily: 'oneUI',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const SensorDataPage(),
    );
  }
}