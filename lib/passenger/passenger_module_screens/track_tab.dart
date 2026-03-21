import 'dart:ui';

import 'package:driver_app/driver/driver_widgets/pulsating_dot.dart';
import 'package:driver_app/driver/driver_widgets/route_card.dart';
import 'package:driver_app/models/route_model.dart';
import 'package:flutter/material.dart';
import 'package:driver_app/passenger/passenger_widgets/live_map_component.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class TrackTab extends StatefulWidget {
  const TrackTab({super.key});

  @override
  State<TrackTab> createState() => _TrackTabState();
}

class _TrackTabState extends State<TrackTab> {
  @override
  void initState() {
    super.initState();
  }

  final PageController _pageController = PageController(viewportFraction: 0.9);

  String _currentJourneyId = "bus-402-demo";

  final List<RouteData> _activeRoutes = [
    RouteData(
      id: "Route 402",
      routeName: "Main Campus",
      status: "Live",
      passengerCount: 32,
      capacity: 45,
    ),
    RouteData(
      id: "Route 105",
      routeName: "Route 105 - Accra Mall",
      status: "Delayed",
      passengerCount: 40,
      capacity: 45,
    ),
    RouteData(
      id: "Route 311",
      routeName: "Route 311 - Madina",
      status: "Live",
      passengerCount: 12,
      capacity: 30,
    ),
  ];

  // Future<void> animateToUser() async {
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) return;

  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) return;
  //   }

  //   final position = await Geolocator.getCurrentPosition();
  //   final userLatLng = LatLng(position.latitude, position.longitude);

  //   setState(() {
  //     _userMarker = Marker(
  //       markerId: const MarkerId('user_location'),
  //       position: userLatLng,
  //       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure), // Blue Pin
  //       infoWindow: const InfoWindow(title: "You are here"),
  //     );
  //   });

  //   _mapController?.animateCamera(CameraUpdate.newLatLngZoom(userLatLng, 15));
  // }

  // @override
  // void dispose() {
  //   _pageController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    LatLng pinPosition = LatLng(37.3797536, -122.1017334);

    // these are the minimum required values to set
    // the camera position
    CameraPosition initialLocation = CameraPosition(zoom: 16, bearing: 30, target: pinPosition);

    return Scaffold(
      body: Stack(
        children: [
          // 1. THE MAP (Base Layer)
          Positioned.fill(child: LiveMapComponent(journeyId: _currentJourneyId)),

          // 2. SLIDABLE ROUTE CAROUSEL (Top overlay)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 0,
            right: 0,
            height: 100, // Fixed height for the routing cards
            child: PageView.builder(
              controller: _pageController,
              itemCount: _activeRoutes.length,
              onPageChanged: (int index) {
                setState(() {
                  _currentJourneyId = _activeRoutes[index].id;
                });
              },
              itemBuilder: (context, index) {
                return buildRouteCard(_activeRoutes[index]);
              },
            ),
          ),

          
        ],
      ),
    );
  }
}
