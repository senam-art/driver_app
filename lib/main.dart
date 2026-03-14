//main.dart is the entry point of the app. It is responsible for running the app and setting the theme and home page.

import 'package:driver_app/driver/driver_module_screens/driver_login.dart';
import 'package:driver_app/driver/driver_module_screens/journey_details_page.dart';
import 'package:driver_app/driver/driver_module_screens/journey_page.dart';
import 'package:driver_app/driver/driver_module_screens/trip_start_screen.dart';
import 'package:driver_app/driver/features/driver_wrapper.dart';
import 'package:driver_app/passenger/passenger_wrapper.dart';
import 'package:driver_app/theme/app_colors.dart';
import 'package:driver_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  // 1. Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Supabase
  await Supabase.initialize(
    url: 'https://gllwtrtbjkercgnuqyjp.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdsbHd0cnRiamtlcmNnbnVxeWpwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE5NTE3NzYsImV4cCI6MjA4NzUyNzc3Nn0.gURz0rj5nZyijdzbnv0VfClGTkbFz4BedIS3IqVRU5M',
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

      home: const PassengerMainWrapper(),
    );
  }
}
