import 'package:driver_app/models/journey_model.dart';
import 'package:driver_app/driver/driver_module_screens/journey_details_page.dart';
import 'package:driver_app/services/journey_service.dart';
import 'package:driver_app/widgets/button_var1.dart';
import 'package:driver_app/widgets/journey_card.dart';
import 'package:flutter/material.dart';

class JourneyPage extends StatelessWidget {
  final List<Journey> journeys = JourneyService.getMockJourneys();

  JourneyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Padding(padding: EdgeInsets.only(top: 30.0), child: Text("Journeys")),
        toolbarHeight: 100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          padding: const EdgeInsets.only(left: 30, top: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          // --- STATIC SECTION ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Buttons Row
                Row(
                  children: [
                    Expanded(
                      child: AppButton(label: "Upcoming", onPressed: () {}),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppButton.text(label: "Past", onPressed: () {}),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                // Header aligned to left
                Text("Today", style: Theme.of(context).textTheme.displayMedium),
              ],
            ),
          ),

          // --- SCROLLABLE SECTION ---
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 0),
              itemCount: journeys.length,
              itemBuilder: (context, index) {
                final currentJourney = journeys[index];
                return JourneyCard(
                  journey: currentJourney,
                  onPressed:
                      () // Navigation to details page
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JourneyDetailsPage(journey: currentJourney),
                          ),
                        );
                      },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
