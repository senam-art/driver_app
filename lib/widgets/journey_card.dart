//journey_card.dart is a widget that will be used to display the journey details in the journey page

import 'package:driver_app/models/journey_model.dart';
import 'package:flutter/material.dart';

class JourneyCard extends StatelessWidget {
  final Journey journey;
  final VoidCallback onPressed;

  const JourneyCard({
    super.key,
    required this.journey,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final fromLocation = journey.firstStop;
    final toLocation = journey.lastStop;
    final int numberOfPassengers = 30;
    final departureTime = journey.departureTime;
    final arrivalTime = journey.arrivalTime;
    final String duration = "1hr 20min";
    final String statusTag = "IN 4 HOURS";
    final numberofStops = journey.middleStopsCount;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            //Top Row: Locations and Status Tag
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$fromLocation to $toLocation",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4), //spacing between location and stats

                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w300,
                                ),

                            children: [
                              TextSpan(text: "$numberOfPassengers Passengers"),
                              TextSpan(
                                text:
                                    "  \u00B7  ", // Added extra spaces around the dot
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                              TextSpan(text: "$numberofStops Stops"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 6.0,
                  ),
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
            const SizedBox(height: 20.0), //for spacing
            //Middle Row: Time and Progress Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _timeColumn(
                  context,
                  departureTime,
                  fromLocation,
                  CrossAxisAlignment.start,
                ), //replace with dynamic labels
                _buildRouteGraphic(duration),
                _timeColumn(
                  context,
                  arrivalTime,
                  toLocation,
                  CrossAxisAlignment.end,
                ),
              ],
            ),
            const SizedBox(height: 15.0), //for spacing
            const Divider(color: Colors.black12, thickness: 1), //divider line
            // Bottom Row: Stats and view details button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 15),
                    Padding(padding: const EdgeInsets.only(left: 4.0)),
                    Text(
                      "$numberOfPassengers",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(width: 15), //spacing between icons
                    const Icon(Icons.adjust_outlined, size: 15),
                    Padding(padding: const EdgeInsets.only(left: 4.0)),
                    Text(
                      "$numberofStops",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: onPressed,
                  child: Row(
                    children: [
                      Text(
                        "VIEW DETAILS",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Color(0xFF1B3A4B),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Color(0xFF1B3A4B)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeColumn(
    BuildContext context,
    String departureTime,
    String station,
    CrossAxisAlignment alignment,
  ) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          departureTime,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13),
        ),

        Text(station, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildRouteGraphic(String duration) {
    return Column(
      children: [
        Text(
          duration,
          style: const TextStyle(color: Colors.grey, fontSize: 10),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.circle_outlined, size: 8, color: Colors.grey),
            SizedBox(
              width: 60,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Divider(color: Colors.grey),
                  Container(
                    color: Colors.white,
                    child: const Icon(
                      Icons.directions_bus,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.circle_outlined, size: 8, color: Colors.grey),
          ],
        ),
      ],
    );
  }
}
