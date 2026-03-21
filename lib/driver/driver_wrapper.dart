import 'package:driver_app/driver/driver_module_screens/driver_homepage.dart';
import 'package:driver_app/driver/driver_module_screens/journey_page.dart';
import 'package:driver_app/driver/driver_module_screens/journeys_tab.dart';
import 'package:flutter/material.dart';
import '../widgets/floating_nav_bar.dart';

class DriverMainScreen extends StatefulWidget {
  const DriverMainScreen({super.key});

  @override
  State<DriverMainScreen> createState() => _DriverMainScreenState();
}

class _DriverMainScreenState extends State<DriverMainScreen> {
  //track which inner part is visible

  int _currentPageIndex = 0;

  // indexedStack so each tab persists in the background
  final List<Widget> _pages = [
    Center(child: DriverHomeTab()),
    Center(child: JourneysTab()),
    Center(child: JourneyPage()), // journey list page
    const Center(child: Text("Profile: Settings & Logout")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // We use a Stack to float the Nav Bar OVER the content
      body: Stack(
        children: [
          // 1. THE INNER PART (The Content)
          IndexedStack(index: _currentPageIndex, children: _pages),

          // 2. THE STATIC PART (The Floating Nav Bar)
          FloatingNavBar(
            currentIndex: _currentPageIndex,
            onTap: (index) {
              // This 'setState' is what triggers the "Inner Part" to change
              setState(() {
                _currentPageIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }
}
