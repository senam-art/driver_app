// lib/features/driver/tabs/journeys_tab.dart
import 'package:driver_app/driver/driver_widgets/schedule_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add 'intl' to your pubspec.yaml

class JourneysTab extends StatefulWidget {
  const JourneysTab({super.key});

  @override
  State<JourneysTab> createState() => _JourneysTabState();
}

class _JourneysTabState extends State<JourneysTab> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildWeeklyCalendar(),
            const Expanded(
              child: TripListView(), // This will show the list of trips
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Text("Trip Schedule", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildWeeklyCalendar() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7, // Show one week of history/future
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          // Calculate the date for each pill
          DateTime date = DateTime.now().add(Duration(days: index));
          bool isSelected = DateUtils.isSameDay(_selectedDate, date);
          bool isToday = DateUtils.isSameDay(DateTime.now(), date);

          return GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: isSelected ? Colors.redAccent : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E').format(date).toUpperCase(), // Mon, Tue, etc.
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white70 : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  if (isToday && !isSelected)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      height: 4,
                      width: 4,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// This widget goes inside the "Expanded" area of your JourneysTab
class TripListView extends StatelessWidget {
  const TripListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        Text(
          "AVAILABLE ROUTES",
          style: TextStyle(
            letterSpacing: 1.2,
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
        SizedBox(height: 16),
        // These will eventually be mapped from your Node.js API
        ScheduleItem(title: "CTK Premises to Ashesi", time: "06:30 AM", passengerCount: 30),
        ScheduleItem(title: "KFC Stanbic to Ashesi", time: "06:45 AM", passengerCount: 30),
        ScheduleItem(title: "Lapaz to Ashesi", time: "06:15 AM", passengerCount: 30),
        ScheduleItem(title: "Temple to Ashesi", time: "07:00 AM", passengerCount: 30),
        ScheduleItem(title: "Spintex to Ashesi", time: "06:00 AM", passengerCount: 30),
      ],
    );
  }
}
