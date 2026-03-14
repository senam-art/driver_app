import 'package:flutter/material.dart';

class PassengerHome extends StatefulWidget {
  @override
  _PassengerHomeState createState() => _PassengerHomeState();
}

class _PassengerHomeState extends State<PassengerHome> {
  // Demo states - these would come from your API
  bool hasActiveBooking = true;
  double walletBalance = 45.50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: () async => print("Refreshing data..."),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. The Dynamic Section
                hasActiveBooking ? _buildPriorityTripCard() : _buildExplorerLayout(),

                const SizedBox(height: 10),

                // 2. Persistent Sections
                const SizedBox(height: 6),
                _buildUpcomingSection(),

                const SizedBox(height: 24),
                _buildSectionHeader("Quick Actions"),
                _buildQuickActionsGrid(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- LAYOUT A: EXPLORER (No Booked Trips) ---
  Widget _buildExplorerLayout() {
    return Column(
      children: [
        // Wallet Card is prominent here
        _buildWalletCard(),
        const SizedBox(height: 20),
        // "Where to?" Search Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: const TextField(
            decoration: InputDecoration(
              icon: Icon(Icons.search, color: Color(0xFFC62828)),
              hintText: "Where are you going?",
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  // --- LAYOUT B: PRIORITY (Trip Booked) ---
  Widget _buildPriorityTripCard() {
    return Column(
      children: [
        // 1. Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Your Next Trip",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 101, 188, 104),
                padding: EdgeInsets.all(8),
              ),
              onPressed: () {},
              child: const Text(
                "On Time",
                style: TextStyle(color: Color.fromARGB(255, 18, 79, 19), fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              Container(
                height: 120,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  image: DecorationImage(
                    image: AssetImage('assets/map_preview.png'), // Add your map image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Berekuso → East Legon",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        // _buildStatusChip("On Time"),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC62828),
                        minimumSize: const Size(double.infinity, 45),
                      ),
                      onPressed: () {},
                      child: const Text("Track Live Location"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- MODULAR COMPONENTS ---

  Widget _buildWalletCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFC62828),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Wallet Balance", style: TextStyle(color: Colors.white70)),
              Text(
                "GH₵ $walletBalance",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          ElevatedButton(onPressed: () {}, child: const Text("Top Up")),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.5,
      children: [
        _quickActionItem(Icons.bookmark_add_outlined, "Book Trip"),
        _quickActionItem(Icons.history, "My Trips"), // Grouped as we discussed
        _quickActionItem(Icons.map_outlined, "Routes"),
        _quickActionItem(Icons.help_outline, "Support"),
      ],
    );
  }

  // Simplified Builders
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        "Ashesi Go",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.person_outline, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }

  Widget _quickActionItem(IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFFC62828)),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildUpcomingSection() {
    return Column(
      children: [
        // 1. Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Upcoming Trips",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: const Text("View All", style: TextStyle(color: Color(0xFFC62828))),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // 2. Horizontal Scrollable List
        SizedBox(
          height: 160, // Fixed height for the horizontal scroll
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 4, // Replace with trips.length
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return _buildTripCard(
                date: "TOMORROW",
                routeName: "East Legon → Campus",
                time: "07:00 AM",
                vehicleName: "Bus AG-105",
                seat: "14A",
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTripCard({
    required String date,
    required String routeName,
    required String time,
    required String vehicleName,
    String? seat,
  }) {
    return Container(
      width: 280, // Matches the proportions in your screenshot
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: const TextStyle(
              color: Color(0xFFC62828),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(routeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text("$time • $vehicleName", style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "SEAT: ${seat ?? 'N/A'}",
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFFC62828), size: 18),
            ],
          ),
        ],
      ),
    );
  }
}
