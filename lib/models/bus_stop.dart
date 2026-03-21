
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



final PointLatLng origin = PointLatLng(5.5786, -0.1856); // Christ the King
final PointLatLng destination = PointLatLng(5.7603, -0.2199); // Ashesi


class BusStop {
  final String id;
  final String name;
  final PolylineWayPoint lat;
  final PolylineWayPoint long;
  final String arrivalTime;

  BusStop({
    required this.id,
    required this.lat,
    required this.long,
    required this.name,
    required this.arrivalTime,
  });
}
