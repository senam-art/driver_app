import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://10.0.2.2:3000/api";

  Future<Map<String, dynamic>> startTrip({
    required String routeId,
    required String driverId,
    required String vehicleId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/driver/start-trip'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"routeId": routeId, "driverId": driverId, "vehicleId": vehicleId}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {"success": true, "journeyId": data['journeyId']};
      } else {
        // This captures the 400 and 404 errors from your Node.js checks
        return {"success": false, "message": data['error'] ?? "Unknown error occurred"};
      }
    } catch (e) {
      return {"success": false, "message": "Could not connect to server. Check your connection."};
    }
  }
}
