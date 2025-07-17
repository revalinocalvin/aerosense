import 'package:flutter/material.dart';

class DeviceStatusFooter extends StatelessWidget {
  const DeviceStatusFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: const [
          Text('Device Online', style: TextStyle(color: Colors.white70, fontSize: 12)),
          SizedBox(height: 4),
          Text('Last Updated 3 Minutes ago', style: TextStyle(color: Colors.white70, fontSize: 12)),
          SizedBox(height: 4),
          Text('Outside weather from WeatherAPI', style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}