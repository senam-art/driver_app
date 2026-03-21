//main.dart is the entry point of the app. It is responsible for running the app and setting the theme and home page.

import 'package:driver_app/driver/driver_module_screens/driver_login.dart';
import 'package:driver_app/driver/driver_module_screens/journey_details_page.dart';
import 'package:driver_app/driver/driver_module_screens/journey_page.dart';
import 'package:driver_app/driver/driver_module_screens/trip_start_screen.dart';
import 'package:driver_app/driver/driver_wrapper.dart';
import 'package:driver_app/passenger/passenger_wrapper.dart';
import 'package:driver_app/theme/app_colors.dart';
import 'package:driver_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // 1. Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load the .env file
  await dotenv.load(fileName: ".env");

  // 2. Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    realtimeClientOptions: const RealtimeClientOptions(
      eventsPerSecond: 10, // Adjust this for smoothness
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ashesi Go',
      theme: AppTheme.lightTheme,
      // home: DriverMainScreen(),
      home: const PassengerMainWrapper(),
    );
  }
}
//repetive in nature
//remove booking
//load money / balance
//select a trip to see on the dashboard