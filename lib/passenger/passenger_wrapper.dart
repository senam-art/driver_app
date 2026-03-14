import 'package:driver_app/passenger/passenger_module_screens/track_tab.dart';
import 'package:driver_app/widgets/passenger/live_map_component.dart';
import 'package:flutter/material.dart';
import 'package:driver_app/passenger/passenger_module_screens/passenger_home.dart';
import 'package:driver_app/widgets/passenger/boarding_flow.dart';

class PassengerMainWrapper extends StatefulWidget {
  const PassengerMainWrapper({super.key});

  @override
  State<PassengerMainWrapper> createState() => _PassengerMainWrapperState();
}

class _PassengerMainWrapperState extends State<PassengerMainWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    PassengerHome(),
    TrackTab(),
    const Center(child: Text("My Tickets & History")),
    const Center(child: Text("Profile & Settings")),
  ];

  // Logic to trigger the full-screen pulsating flow
  void _startBoardingFlow() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Crucial: Allows full-height
      useSafeArea: true, // Crucial: Prevents bottom bar overflow
      backgroundColor: Colors.transparent,
      builder: (context) => const BoardingFlowContainer(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: _startBoardingFlow, // Triggers the flow
        backgroundColor: const Color(0xFFC62828),
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.nfc, color: Colors.white, size: 30),
      ),

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        padding: EdgeInsets.zero, // Removes default padding that causes overflow
        height: 70, // Explicitly set height to keep it consistent
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              if (index == 2) return; // Prevent dead click on spacer
              setState(() => _selectedIndex = index);
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFFC62828),
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.transparent, // Required to show the BottomAppBar shape
            elevation: 0,
            selectedFontSize: 12, // Smaller fonts help prevent overflows
            unselectedFontSize: 12,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: 'Track'),
              BottomNavigationBarItem(icon: Icon(null), label: ''), // Spacer
              BottomNavigationBarItem(
                icon: Icon(Icons.confirmation_num_outlined),
                label: 'Tickets',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}
