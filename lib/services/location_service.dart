// import 'package:supabase_flutter/supabase_flutter.dart';

// void startBroadcastingLocation(String journeyId) {
//   final channel = Supabase.instance.client.channel('journey_$journeyId');

//   Geolocator.getPositionStream().listen((Position position) {
//     channel.sendBroadcast(
//       event: 'location_update',
//       payload: {
//         'lat': position.latitude,
//         'lng': position.longitude,
//         'heading': position.heading, // Useful for rotating the bus icon!
//       },
//     );
//   });
// }
