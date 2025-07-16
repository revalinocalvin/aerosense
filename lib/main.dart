import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AeroSenseApp());
}

class AeroSenseApp extends StatelessWidget {
  const AeroSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AeroSense',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const SensorDataPage(),
    );
  }
}

class SensorDataPage extends StatefulWidget {
  const SensorDataPage({super.key});

  @override
  State<SensorDataPage> createState() => _SensorDataPageState();
}

class _SensorDataPageState extends State<SensorDataPage> {
  double temperature = 0;
  double humidity = 0;
  double gas = 0;
  double dust = 0;

  @override
  void initState() {
    super.initState();
    fetchSensorData();
  }

  void fetchSensorData() async {
    final databaseReference = FirebaseDatabase.instance.ref();
    final snapshot = await databaseReference.child('AirMonitor').get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);

      if (data != null) {
        final logs = Map<String, dynamic>.from(data['Logs'] ?? {});
        setState(() {
          humidity = (data['Humidity'] ?? 0).toDouble();
          gas = (data['MQ135'] ?? 0).toDouble();
          temperature = (data['Temperature'] ?? 0).toDouble();
          dust = 0.0;
        });
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AeroSense Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Temperature: ${temperature.toStringAsFixed(1)} °C', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 12),
            Text('Humidity: ${humidity.toStringAsFixed(1)} %', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 12),
            Text('Gas: ${gas.toStringAsFixed(1)} ppm', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 12),
            Text('Dust: ${dust.toStringAsFixed(1)} µg/m³', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
