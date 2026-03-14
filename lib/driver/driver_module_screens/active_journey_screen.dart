import 'package:flutter/material.dart';
import '/widgets/driver/slider_button.dart'; // We reuse the slider we built earlier

class ActiveJourneyPage extends StatefulWidget {
  const ActiveJourneyPage({super.key});

  @override
  State<ActiveJourneyPage> createState() => _ActiveJourneyPageState();
}

class _ActiveJourneyPageState extends State<ActiveJourneyPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // 95% height gives it that "Floating over the Nav Bar" look
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          // 1. DRAG HANDLE & HEADER
          _buildDragHandle(),
          _buildHeader(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "ROUTE TIMELINE",
                    style: TextStyle(
                      letterSpacing: 1.5,
                      color: Color(0xFF8E9BA7),
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 2. TIMELINE SECTION
                  _buildTimelineItem(
                    "CTK (Christ the King)",
                    "Departed at 07:30 AM",
                    status: "completed",
                  ),
                  _buildTimelineItem("37 Bus Stop", "Current Location", status: "active"),
                  _buildTimelineItem("Spanner", "Est. Arrival: 08:05 AM", status: "upcoming"),
                  _buildTimelineItem(
                    "Shiashie",
                    "Est. Arrival: 08:20 AM",
                    status: "upcoming",
                    isLast: true,
                  ),

                  const SizedBox(height: 32),

                  // 3. RECENT NFC TAPS SECTION
                  _buildNfcSection(),

                  const SizedBox(height: 24),

                  // 4. MAP PREVIEW
                  // _buildMapSection(),
                  const SizedBox(height: 120), // Padding so the slider doesn't cover content
                ],
              ),
            ),
          ),

          // 5. SLIDE TO DEPART (Fixed at bottom)
          _buildBottomAction(),
        ],
      ),
    );
  }

  // --- SUB-WIDGETS ---

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 12, bottom: 8),
        height: 5,
        width: 45,
        decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.directions_bus_filled, color: Colors.redAccent),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Accra - Ashesi",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    const Icon(Icons.fiber_manual_record, color: Colors.green, size: 8),
                    const SizedBox(width: 4),
                    Text(
                      "IN PROGRESS • ETA: 45M",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "LIVE",
              style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    String title,
    String subtitle, {
    String status = "upcoming",
    bool isLast = false,
  }) {
    Color mainColor = status == "completed" || status == "active"
        ? Colors.redAccent
        : Colors.grey[300]!;

    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              status == "completed"
                  ? const Icon(Icons.check_circle, color: Colors.redAccent, size: 22)
                  : status == "active"
                  ? const Icon(Icons.radio_button_checked, color: Colors.redAccent, size: 22)
                  : Icon(Icons.radio_button_off, color: Colors.grey[300], size: 22),
              if (!isLast) Expanded(child: Container(width: 2, color: Colors.grey[200])),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: status == "active" ? const EdgeInsets.all(12) : EdgeInsets.zero,
              decoration: status == "active"
                  ? BoxDecoration(
                      color: Colors.red[50]!.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.red[100]!),
                    )
                  : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: status == "active" ? FontWeight.bold : FontWeight.normal,
                          color: status == "completed" ? Colors.grey : Colors.black,
                          decoration: status == "completed" ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                    ],
                  ),
                  if (status == "active")
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        "BOARDING",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNfcSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.nfc, size: 18, color: Colors.redAccent),
                  SizedBox(width: 8),
                  Text(
                    "RECENT NFC TAPS",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
              const Text("12 / 30 Seats", style: TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 20),
          _buildTapTile("Kojo Mensah", "STUDENT ID: 88292024", "Just now", "KM"),
          _buildTapTile("Abena Osei", "STUDENT ID: 12932025", "2m ago", "AO"),
          _buildTapTile("Yaw Adom", "FACULTY ID: 44221002", "5m ago", "YA"),
        ],
      ),
    );
  }

  Widget _buildTapTile(String name, String id, String time, String initials) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.red[50],
            radius: 18,
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(
                  id,
                  style: TextStyle(color: Colors.grey[500], fontSize: 10, letterSpacing: 0.5),
                ),
              ],
            ),
          ),
          Text(time, style: TextStyle(color: Colors.grey[400], fontSize: 11)),
        ],
      ),
    );
  }

  // Widget _buildMapSection() {
  //   return Stack(
  //     children: [
  //       ClipRRect(
  //         borderRadius: BorderRadius.circular(24),
  //         child: Image.network(
  //           'https://maps.googleapis.com/maps/api/staticmap?center=5.65,-0.18&zoom=13&size=600x250&key=KEY',
  //           height: 140,
  //           width: double.infinity,
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //       Positioned(
  //         bottom: 12,
  //         left: 12,
  //         child: ElevatedButton.icon(
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Colors.white,
  //             foregroundColor: Colors.black,
  //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //             elevation: 2,
  //           ),
  //           onPressed: () {},
  //           icon: const Icon(Icons.map_outlined, size: 16),
  //           label: const Text(
  //             "View Full Map",
  //             style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 34),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ActionSlider(
        sliderText: "SLIDE TO DEPART",
        onAction: () {
          print("🚌 Moving to next stop...");
        },
      ),
    );
  }
}
