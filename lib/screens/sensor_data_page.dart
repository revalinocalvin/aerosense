import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/air_quality_card.dart';
import '../widgets/device_status_footer.dart';
import '../widgets/metric_card.dart';
import '../widgets/temp_display.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/outsidetemp_model.dart';
import '../services/outsidetemp_service.dart';
import 'dart:async';

class SensorDataPage extends StatefulWidget {
  const SensorDataPage({super.key});

  @override
  State<SensorDataPage> createState() => _SensorDataPageState();
}

class _SensorDataPageState extends State<SensorDataPage> {
  late DatabaseReference _databaseReference;

  String _deviceStatus = "Device Offline";
  DateTime? _lastUpdateTime;
  Timer? _offlineTimer;
  Timer? _updateTimer;

  Map<String, dynamic>? _previousData;
  bool _isFirstLoad = true;

  // Sensor values
  double roomTemp = 31.0;
  double outsideTemp = 27.0;
  double humidity = 73.0;
  double pm25 = 40.1;
  double airToxins = 489.0;

  // ADD THESE NEW VARIABLES
  late final OutsideTempService _outsideTempService;
  String _cityName = "Loading...";
  double? _apiOutsideTemp; // This will hold the temp from the API

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.ref().child('AirMonitor');
    _outsideTempService = OutsideTempService("c13ff63382e04ae3ab3165209251707");
    _initializeWeather(); // Kick off the location and weather fetching process

    // ✅ Use distinct() to prevent rebuild spam
    _databaseReference
        .onValue
        .distinct((prev, next) => prev.snapshot.value == next.snapshot.value)
        .listen((event) {
      final rawData = event.snapshot.value;
      if (rawData != null && rawData is Map) {
        final data = Map<String, dynamic>.from(rawData);

        if (_previousData == null || !_mapEquals(_previousData!, data)) {
          _previousData = data;

          // Update sensor values
          roomTemp = (data['Temperature'] ?? 31.0).toDouble();
          outsideTemp = (data['OutsideTemp'] ?? 27.0).toDouble();
          humidity = (data['Humidity'] ?? 73.0).toDouble();
          pm25 = (data['PM25'] ?? 40.1).toDouble();
          airToxins = (data['MQ135'] ?? 489.0).toDouble();

          // Device status logic
          if (!_isFirstLoad) {
            _updateStatus();
          } else {
            _isFirstLoad = false;
          }

          setState(() {}); // Refresh UI
        }
      }
    });

    // Timer for footer refresh every 1 minute
    _updateTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (_lastUpdateTime != null) {
        setState(() {}); // Refresh footer
      }
    });
  }

  // ADD THIS FUNCTION
  void _initializeWeather() async {
    // First, try to load any cached data to show it instantly
    await _loadCachedData();

    // Then, fetch live data.
    try {
      final newTempData = await _outsideTempService.getOutsideTempByCurrentLocation();

      // If successful, update the UI and save the new data
      if (mounted) {
        setState(() {
          _cityName = newTempData.cityName;
          _apiOutsideTemp = newTempData.temperature;
        });
        _saveCachedData(newTempData);
      }
    } catch (e) {
      // If fetching fails (e.g., no permission, no internet), update city name to show an error
      if (mounted) {
        setState(() {
          _cityName = "Could not get location";
        });
      }
      print("Weather Service Error: $e");
    }
  }

// ADD THIS FUNCTION
  Future<void> _loadCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedCity = prefs.getString('lastCityName');
    final cachedTemp = prefs.getDouble('lastOutsideTemp');

    if (cachedCity != null && cachedTemp != null) {
      if (mounted) {
        setState(() {
          _cityName = cachedCity;
          _apiOutsideTemp = cachedTemp;
        });
      }
    }
  }

// ADD THIS FUNCTION
  Future<void> _saveCachedData(OutsideTemp data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastCityName', data.cityName);
    await prefs.setDouble('lastOutsideTemp', data.temperature);
  }

  void _resetOfflineTimer() {
    _offlineTimer?.cancel();
    _offlineTimer = Timer(const Duration(minutes: 3), () {
      setState(() {
        _deviceStatus = "Device Offline";
      });
    });
  }

  void _updateStatus() {
    setState(() {
      _deviceStatus = "Device Online";
      _lastUpdateTime = DateTime.now();
    });
    _resetOfflineTimer();
  }

  String _calculateLastUpdatedText() {
    if (_lastUpdateTime == null) return "Not yet updated";
    final diff = DateTime.now().difference(_lastUpdateTime!);
    if (diff.inMinutes == 0) return "Updated just now";
    return "Last updated ${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago";
  }

  bool _mapEquals(Map<String, dynamic> a, Map<String, dynamic> b) {
    if (a.length != b.length) return false;
    for (var key in a.keys) {
      if (a[key] != b[key]) return false;
    }
    return true;
  }

  @override
  void dispose() {
    _offlineTimer?.cancel();
    _updateTimer?.cancel();
    super.dispose();
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
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _handleRefresh,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _cityName,
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
                                  TempDisplay(label: 'Outside', temp: _apiOutsideTemp ?? outsideTemp),
                                ],
                              ),
                              const SizedBox(height: 32),
                              AirQualityCard(pm25: pm25),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Expanded(
                                      child: MetricCard(
                                          icon: Icons.water_drop_outlined,
                                          label: 'Humidity',
                                          value: '${humidity.toInt()}%')),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: MetricCard(
                                          icon: Icons.filter_drama_outlined,
                                          label: 'PM 2.5',
                                          value: pm25.toStringAsFixed(1))),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: MetricCard(
                                          icon: Icons.cloud_outlined,
                                          label: 'Air Toxins',
                                          value: airToxins.toInt().toString())),
                                ],
                              ),
                              const SizedBox(height: 48),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewPadding.bottom + 16,
                    ),
                    child: DeviceStatusFooter(
                      deviceStatus: _deviceStatus,
                      lastUpdated: _calculateLastUpdatedText(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
