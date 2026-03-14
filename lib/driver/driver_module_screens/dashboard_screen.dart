import 'package:flutter/material.dart';
// import '../widgets/passenger_log_card.dart';
// import '../widgets/quick_action_buttons.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Dashboard'),
      ),
      body: Column(
        children: [
          // Collapsible card for route & stops
          Expanded(
            child: ListView(
              children: const [
                // PassengerLogCard(),
                // QuickActionButtons(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
        ],
      ),
    );
  }
}