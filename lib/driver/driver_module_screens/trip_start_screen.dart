import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

class TripStartScreen extends StatelessWidget {
  const TripStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to Dashboard
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
            );
          },
          child: const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Start Trip',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}