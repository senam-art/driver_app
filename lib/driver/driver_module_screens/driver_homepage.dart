import 'package:driver_app/driver/driver_module_screens/active_journey_screen.dart';
import 'package:driver_app/services/api_service.dart';
import 'package:driver_app/theme/app_colors.dart';
import 'package:driver_app/widgets/ashesi_map.dart';
import 'package:driver_app/driver/driver_widgets/schedule_item.dart';
import 'package:driver_app/driver/driver_widgets/slider_button.dart';
import 'package:driver_app/driver/driver_widgets/stat_card.dart';
import 'package:flutter/material.dart';

class DriverHomeTab extends StatefulWidget {
  const DriverHomeTab({super.key});

  @override
  State<DriverHomeTab> createState() => _DriverHomeTabState();
}

class _DriverHomeTabState extends State<DriverHomeTab> {
  bool _isTripActive = false;
  final ApiService _apiService = ApiService();
  // This key specifically targets the State of the ActionSlider
  final GlobalKey<ActionSliderState> _sliderKey = GlobalKey<ActionSliderState>();

  void _showActiveJourney(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true, // Allows the "Drag Down" minimize behavior
      builder: (context) => const ActiveJourneyPage(),
    );
  }

  void _handleStartTrip() async {
    // Show a loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Starting trip..."), duration: Duration(seconds: 1)),
    );

    final result = await _apiService.startTrip(
      routeId: "408ec9bf-e1b4-4f90-8837-1b98f6b4e897", // This will come from your Dashboard API
      driverId: "a55b48d6-997d-42d5-9e29-dab63ffd1950", // This will come from your Auth/Profile
      vehicleId:
          "b017d8d9-b4d0-4dbe-a0b4-546c9e6be481", // This will be selected or hardcoded for demo
    );

    if (result['success']) {
      setState(() => _isTripActive = true);
      _showActiveJourney(context);
    } else {
      // If it fails, tell the slider to reset itself
      _sliderKey.currentState?.reset();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      // Show the professional error message from your Node.js checks
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /*
-----------------------------------------------
U I
---------------------------------------------
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Light grey background to make white pills pop
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 120), // Padding for the Floating Nav Bar
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. THE HEADER PILL
              _buildHeaderPill(),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "TODAY'S OVERVIEW",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                    letterSpacing: 1.2,
                    fontSize: 12,
                  ),
                ),
              ),

              // 2. STATS ROW
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    StatCard(label: "TOTAL TRIPS", value: "06", icon: Icons.directions_bus),
                    StatCard(label: "PASSENGERS", value: "142", icon: Icons.people_alt),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 3. THE IMMEDIATE TRIP CARD (Map + Slide)
              _buildImmediateTripCard(),

              const SizedBox(height: 24),

              // 4. OTHER UPCOMING TRIPS Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "OTHER TRIPS",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text("View All", style: TextStyle(color: Colors.redAccent)),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: const [
                    ScheduleItem(title: "Ashesi to Berekuso", time: "08:00 AM", passengerCount: 32),
                    ScheduleItem(title: "Berekuso to Ashesi", time: "10:30 AM", passengerCount: 28),
                    ScheduleItem(
                      title: "Ashesi to Accra Central",
                      time: "02:00 PM",
                      passengerCount: 40,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI PIECES (Modular Methods) ---

  Widget _buildHeaderPill() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: kElevationToShadow[3],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blueGrey,
                  ), // Replace with Image.asset
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "WELCOME BACK,",
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Kofi Mensah",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          _iconCircle(Icons.notifications_none_outlined, hasBadge: true),
          const SizedBox(width: 8),
          _iconCircle(Icons.chat_bubble_outline),
        ],
      ),
    );
  }

  Widget _buildImmediateTripCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. THE MAP SECTION (Top Layer)
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: const SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: AshesiFreeMap(), // Your custom map class
                ),
              ),
              // The "Status" Tag positioned over the map
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: (_isTripActive ? Colors.green : const Color(0xFFAE2727)).withValues(
                      alpha: 0.9,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _isTripActive ? 'LIVE' : 'NEXT UP',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 2. THE CONTENT SECTION
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dynamic Status Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isTripActive ? "HAPPENING NOW" : "SCHEDULED TRIP",
                      style: TextStyle(
                        color: _isTripActive ? Colors.green : Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        letterSpacing: 1.1,
                      ),
                    ),
                    if (_isTripActive) const Icon(Icons.sensors, color: Colors.green, size: 16),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  "CTK Premises to Ashesi University",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D2534),
                  ),
                ),
                const SizedBox(height: 8),

                // Time and Passenger Info
                Row(
                  children: const [
                    Icon(Icons.access_time, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text("6:30 AM", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    SizedBox(width: 16),
                    Icon(Icons.people_outline, size: 14, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      "30 Seats",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ), // Fixed to 30
                  ],
                ),

                const SizedBox(height: 24),

                // THE DYNAMIC ACTION BUTTON
                // If trip is active, show "Return" button. If not, show the "Slider".
                _isTripActive
                    ? _buildReturnButton()
                    : ActionSlider(
                        key: _sliderKey,
                        sliderText: "SLIDE TO START TRIP",
                        onAction: () {
                          _handleStartTrip(); // Sets state and opens modal
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconCircle(IconData icon, {bool hasBadge = false}) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.black87, size: 22),
        ),
        if (hasBadge)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              height: 8,
              width: 8,
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
            ),
          ),
      ],
    );
  }

  Widget _buildReturnButton() {
    return InkWell(
      onTap: () => _showActiveJourney(context), // Re-opens the modal sheet
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F4F8),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.green.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.open_in_full_rounded, color: Colors.green, size: 18),
            SizedBox(width: 10),
            Text(
              "RETURN TO ACTIVE TRIP",
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
