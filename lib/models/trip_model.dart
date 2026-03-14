class Trip {
  final String id;
  final String date;
  final String routeName;
  final String time;
  final String vehicleName;
  final String seat;

  Trip({
    required this.id,
    required this.date,
    required this.routeName,
    required this.time,
    required this.vehicleName,
    required this.seat,
  });

  // The "Translator" factory
  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] ?? '',
      // We format the date/time logic here
      date: json['scheduled_day'] ?? 'UPCOMING', 
      routeName: json['routes']['route_name'] ?? 'Unknown Route',
      time: json['scheduled_time'] ?? '--:--',
      vehicleName: json['vehicles']?['license_plate'] ?? 'TBD',
      seat: json['seat_number'] ?? 'Open',
    );
  }
}