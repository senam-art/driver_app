// journey_model.dart

class BusStop {
  final String name;
  final String arrivalTime;
  final int boarding; // ↑ icon
  final int alighting; // ↓ icon
  final int totalOnBoard; // Person icon
  final bool isStartingPoint;
  final bool isEndingPoint;

  BusStop({
    required this.name,
    required this.arrivalTime,
    this.alighting = 0,
    this.boarding = 0,
    this.totalOnBoard = 0,
    this.isEndingPoint = false,
    this.isStartingPoint = false,
  });
}

class Journey {
  final String routeName;
  final String busDetails; // e.g., "White & Purple Toyota Coaster"
  final String licensePlate; // GX 1834-17
  final String driverName; // Mr. Tetteh McCarthy
  final String driverPhone;
  final List<BusStop> stops;

  Journey({
    required this.routeName,
    required this.busDetails,
    required this.licensePlate,
    required this.driverName,
    required this.driverPhone,
    required this.stops,
  });

  // Helper getters to make UI code cleaner
  String get firstStop => stops.first.name;
  String get lastStop => stops.last.name;
  String get departureTime => stops.first.arrivalTime;
  String get arrivalTime => stops.last.arrivalTime;
  int get stopCount => stops.length - 2; // Excludes start and end
  int get middleStopsCount => stops.length - 2;
}
