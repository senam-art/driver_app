import 'package:driver_app/models/bus_stop.dart';

class RouteData {
  final String id; // Added ID
  final String routeName;
  final String status;
  final int passengerCount;
  final int capacity;
  final List<BusStop> busStops;

  RouteData({
    required this.id,
    required this.routeName,
    required this.status,
    required this.passengerCount,
    required this.capacity,
    required this.busStops
  });
}
