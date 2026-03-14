import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> runConnectionDiagnostic() async {
  // Use 10.0.2.2 for Android Emulator
  final String url = "http://10.21.17.151:3000/api/health";

  try {
    print("------- 🛰️ DIAGNOSTIC START -------");
    final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      print("✅ SUCCESS: Server reached!");
      print("📦 Server says: ${body['message']}");
      print("🗄️ Database Sample: ${body['data']}");
    } else {
      print("⚠️ SERVER ERROR: Status Code ${response.statusCode}");
      print("💬 Response: ${response.body}");
    }
  } catch (e) {
    print("❌ CONNECTION FAILED!");
    if (e.toString().contains("SocketException")) {
      print("Hint: The emulator cannot see the server. Is the IP 10.0.2.2?");
    } else {
      print("Error Detail: $e");
    }
  }
  print("------- 🛰️ DIAGNOSTIC END -------");
}
