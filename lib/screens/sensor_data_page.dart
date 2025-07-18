import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/air_quality_card.dart';
import '../widgets/device_status_footer.dart';
import '../widgets/metric_card.dart';
import '../widgets/temp_display.dart';

class SensorDataPage extends StatefulWidget {
  const SensorDataPage({super.key});

  @override
  State<SensorDataPage> createState() => _SensorDataPageState();
}

class _SensorDataPageState extends State<SensorDataPage> {
  late DatabaseReference _databaseReference;

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.ref().child('AirMonitor');
  }

  Future<void> _handleRefresh() async {
    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0D47A1), Color(0xFF2196F3)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Main content
            StreamBuilder(
              stream: _databaseReference.onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading data.', style: TextStyle(color: Colors.white)));
                }
                if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
                  return const Center(child: Text('No data available.', style: TextStyle(color: Colors.white)));
                }

                final data = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
                final roomTemp = (data['Temperature'] ?? 31.0).toDouble();
                final humidity = (data['Humidity'] ?? 73.0).toDouble();
                final airToxins = (data['MQ135'] ?? 489.0).toDouble();
                final pm25 = (data['PM25'] ?? 40.1).toDouble();
                final outsideTemp = (data['OutsideTemp'] ?? 27.0).toDouble();

                return RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: SafeArea(
                    bottom: false,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Jakarta',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TempDisplay(label: 'Room', temp: roomTemp),
                                TempDisplay(label: 'Outside', temp: outsideTemp),
                              ],
                            ),
                            const SizedBox(height: 32),
                            AirQualityCard(pm25: pm25),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(child: MetricCard(icon: Icons.water_drop_outlined, label: 'Humidity', value: '${humidity.toInt()}%')),
                                const SizedBox(width: 8),
                                Expanded(child: MetricCard(icon: Icons.filter_drama_outlined, label: 'PM 2.5', value: pm25.toStringAsFixed(1))),
                                const SizedBox(width: 8),
                                Expanded(child: MetricCard(icon: Icons.cloud_outlined, label: 'Air Toxins', value: airToxins.toInt().toString())),
                              ],
                            ),
                            const SizedBox(height: 48),
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewPadding.bottom + 16,
                              ),
                              child: Center(
                                child: Column(
                                  children: const [
                                    Text('Device Online', style: TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.w300)),
                                    SizedBox(height: 4),
                                    Text('Last Updated 3 Minutes ago', style: TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.w300)),
                                    SizedBox(height: 4),
                                    Text('Outside weather from WeatherAPI', style: TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.w300)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
