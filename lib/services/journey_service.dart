import 'package:driver_app/models/journey_model.dart';

// lib/services/journey_service.dart

class JourneyService {
  // This simulates a database fetch
  static List<Journey> getMockJourneys() {
    return [
      Journey(
        routeName: "CTK Premises to Ashesi",
        busDetails: "White & Purple Toyota Coaster (30 seater)",
        licensePlate: "GX 1834-17",
        driverName: "Mr. Tetteh McCarthy",
        driverPhone: "0242780788",
        stops: [
          BusStop(name: "CTK Premises", arrivalTime: "6:30AM"),
          BusStop(name: "37 Bus Stop", arrivalTime: "6:35AM"),
          BusStop(name: "Spanner", arrivalTime: "6:40am"),
          BusStop(name: "Shiashie", arrivalTime: "6:42am"),
          BusStop(name: "Okponglo", arrivalTime: "6:45am"),
          BusStop(name: "Atomic Junction", arrivalTime: "6:50am"),
          BusStop(name: "Adenta Police", arrivalTime: "7:00am"),
          BusStop(name: "Oyarifa Shell", arrivalTime: "7:05am"),
          BusStop(name: "Ashesi University", arrivalTime: "7:50AM"),
        ],
      ),
    ];
  }
}
