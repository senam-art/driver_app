import 'package:driver_app/models/journey_model.dart';
import 'package:driver_app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class JourneyDetailsPage extends StatelessWidget {
  final Journey journey;

  const JourneyDetailsPage({super.key, required this.journey});

  @override
  Widget build(BuildContext context) {
    // Using your getters for the CTK/Ashesi route data
    final firstStop = journey.firstStop;
    final lastStop = journey.lastStop;
    const String statusTag = "IN 4 HOURS";
    final int numberOfPassengers = 30; // Matches Coaster capacity
    final int numberofStops = journey.middleStopsCount;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 3,
        // Override global theme size only
        titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(fontSize: 18),
        title: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Text("$firstStop to $lastStop"),
        ),
        toolbarHeight: 100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          padding: const EdgeInsets.only(top: 30),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color.fromARGB(255, 85, 10, 0),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Added to prevent overflow when you add more content
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: Column(
            children: [
              // JOURNEY SUMMARY CARD
              Container(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left Side: Route and Stats
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$firstStop to $lastStop",
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              children: [
                                TextSpan(text: "$numberOfPassengers Passengers"),
                                const TextSpan(
                                  text: "  \u00B7  ",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                TextSpan(text: "$numberofStops Stops"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Right Side: Status Tag
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        statusTag,
                        style: TextStyle(
                          color: Colors.red[400],
                          fontWeight: FontWeight.w900,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              //Journey Details
              Container(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Journey Details",
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 17),
                    ),
                    TextButton(
                      onPressed: () => {},
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, size: 17, color: Colors.grey),
                          SizedBox(width: 3),
                          Text("Info", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              //journey card
              _buildMainJourneyCard(context, journey),

              SizedBox(height: 12),
              //end button
              _startJourneyButton(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildMainJourneyCard(BuildContext context, Journey journey) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      //outline
      border: Border.all(color: Colors.grey, width: 1), // make it transparent
    ),
    child: Column(
      children: [
        _buildCardHeader(context),
        const Divider(height: 1),
        _buildMapPreview(),
        const SizedBox(height: 20),
        _buildVerticalTimeline(context, journey),
        SizedBox(height: 20),
      ],
    ),
  );
}

Widget _buildCardHeader(BuildContext context) {
  return Padding(
    padding: const EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //Left side passenger count and stops
        Row(
          children: [
            const Icon(Icons.person_outlined, size: 16, color: Colors.grey),
            SizedBox(width: 4),
            const Text("48", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            SizedBox(width: 8),
            const Icon(Icons.adjust_outlined, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            const Text("28", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
        Row(
          //right side info elapsed time and kms
          children: [
            const Icon(Icons.access_time, size: 16, color: Colors.teal),
            const SizedBox(width: 4),
            const Text("7:04 hrs", style: TextStyle(fontSize: 11)),
            const SizedBox(width: 12),
            const Icon(Icons.near_me_outlined, size: 16, color: Colors.teal),
            const SizedBox(width: 4),
            const Text("647 kms", style: TextStyle(fontSize: 11)),
          ],
        ),
      ],
    ),
  );
}

Widget _buildMapPreview() {
  return Container(
    margin: const EdgeInsets.all(16),
    height: 160,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.blue[50]),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          const Center(child: Icon(Icons.map, size: 40, color: Colors.blue)),
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
              ),
              child: const Text(
                "OPEN MAP VIEW",
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildVerticalTimeline(BuildContext context, Journey journey) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: journey.stops.length,
    itemBuilder: (context, index) {
      final stop = journey.stops[index];
      final bool isFirst = index == 0;
      final bool isLast = index == journey.stops.length - 1;

      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. LEFT SIDE: Time and Name
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isFirst
                          ? "Starting Point ${stop.arrivalTime}"
                          : isLast
                          ? "Ending Point ${stop.arrivalTime}"
                          : stop.arrivalTime,
                      style: TextStyle(
                        color: Colors.teal[700],
                        fontSize: 12,
                        fontWeight: isFirst || isLast ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      stop.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isFirst || isLast ? FontWeight.bold : FontWeight.w500,
                        color: Colors.blueGrey[900],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // 2. CENTER: The Track and Dots
            SizedBox(
              width: 30,
              child: Stack(
                alignment: Alignment.topCenter, // Ensures everything is centered horizontally
                children: [
                  // LAYER A: The Green Track
                  Positioned(
                    top: 0,
                    bottom: 0,
                    // We remove left/right and use Center() widget instead to guarantee alignment
                    child: Center(
                      child: Container(
                        width: 16, // Fixed width for the track
                        decoration: BoxDecoration(
                          color: const Color(0xFF2EBD85), // Mint Green
                          borderRadius: BorderRadius.vertical(
                            top: isFirst ? const Radius.circular(8) : Radius.zero,
                            bottom: isLast ? const Radius.circular(8) : Radius.zero,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // LAYER B: The Dots (Customized per position)
                  Positioned(
                    top: 18, // Aligns with the text baseline
                    child: _buildDot(isFirst, isLast),
                  ),
                ],
              ),
            ),

            // 3. RIGHT SIDE: Stats
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0, top: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (stop.alighting > 0) ...[
                      const Icon(Icons.arrow_downward, size: 14, color: Colors.blueGrey),
                      Text("${stop.alighting}  ", style: const TextStyle(fontSize: 12)),
                    ],
                    const Icon(Icons.arrow_upward, size: 14, color: Colors.blueGrey),
                    Text("${stop.boarding}  ", style: const TextStyle(fontSize: 12)),
                    const Icon(Icons.person_outline, size: 14, color: Colors.blueGrey),
                    Text("${stop.totalOnBoard}", style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

// Helper widget to keep the main logic clean
Widget _buildDot(bool isFirst, bool isLast) {
  if (isFirst) {
    // START DOT: Dark center with faint ring
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: const Color(0xFF004D40), // Dark Teal
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.5), // Faint ring
          width: 2,
        ),
      ),
    );
  } else if (isLast) {
    // END DOT: Red center with faint ring
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: Colors.redAccent,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.5), // Faint ring
          width: 2,
        ),
      ),
    );
  } else {
    // MIDDLE DOT: Simple white dot
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
    );
  }
}

Widget _startJourneyButton() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: SizedBox(
      width: double.infinity, // Makes the button stretch to full width
      height: 50, // Standard height for action buttons
      child: ElevatedButton(
        onPressed: () {
          // Add your action here
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.textMain, // That dark navy blue color
          foregroundColor: Colors.white, // Text color
          elevation: 0, // Flat look
          // THE FIX: This removes all roundness
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        child: const Text(
          "Start Journey",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    ),
  );
}
