import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AshesiFreeMap extends StatelessWidget {
  const AshesiFreeMap({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(5.7597, -0.2197), // Ashesi University
        initialZoom: 15.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.driver_app', // Use your app ID
        ),
        const MarkerLayer(
          markers: [
            Marker(
              point: LatLng(5.7597, -0.2197),
              width: 80,
              height: 80,
              child: Icon(Icons.location_on, color: Colors.red, size: 40),
            ),
          ],
        ),
      ],
    );
  }
}
