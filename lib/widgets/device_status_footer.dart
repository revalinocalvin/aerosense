import 'package:flutter/material.dart';

class DeviceStatusFooter extends StatelessWidget {
  final String deviceStatus;
  final String lastUpdated;

  const DeviceStatusFooter({
    super.key,
    required this.deviceStatus,
    required this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(deviceStatus, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 4),
          Text(lastUpdated, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 4),
          const Text('Outside weather from WeatherAPI', style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}
