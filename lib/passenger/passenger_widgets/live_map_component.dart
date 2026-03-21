import 'dart:async';

import 'package:driver_app/models/bus_stop.dart';
import 'package:driver_app/passenger/passenger_widgets/location_access.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:driver_app/config.dart';
import 'package:driver_app/passenger/passenger_widgets/location_access.dart';

// const double CAMERA_ZOOM = 13;
// const double CAMERA_TILT = 0;
// const double CAMERA_BEARING = 30;
// const LatLng SOURCE_LOCATION = LatLng(42.7477863, -71.1699932);
// const LatLng DEST_LOCATION = LatLng(42.6871386, -71.2143403);

// Define your points
final PointLatLng origin = PointLatLng(5.5786, -0.1856); // Christ the King
final PointLatLng destination = PointLatLng(5.7603, -0.2199); // Ashesi

List<PolylineWayPoint> waypoints = [
  PolylineWayPoint(location: "5.5898,-0.1822"), // 37 Bus Stop
  PolylineWayPoint(location: "5.6255,-0.1743"), // Spanner
  PolylineWayPoint(location: "5.6322,-0.1705"), // Shiashie
  PolylineWayPoint(location: "5.6450,-0.1650"), // Okponglo
  PolylineWayPoint(location: "5.6700,-0.1490"), // Atomic Junction
  PolylineWayPoint(location: "5.7060,-0.1330"), // Adenta Police Station
  PolylineWayPoint(location: "5.7330,-0.1330"), // Oyarifa Shell
  PolylineWayPoint(location: "5.7410,-0.1450"), // Teiman/Abokobi
];
List<BusStop> busStops = [];


class LiveMapComponent extends StatefulWidget {
  final String journeyId;

  const LiveMapComponent({super.key, required this.journeyId});

  @override
  State<LiveMapComponent> createState() => _LiveMapComponentState();
}

class _LiveMapComponentState extends State<LiveMapComponent> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(5.578919352595437, -0.18591531874855238),
    zoom: 14.476,
  );

  static const CameraPosition _kLake = CameraPosition(
    target: LatLng(5.579581389206836, -0.19193419574364426),
    bearing: 192.8334901395799,
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  CameraPosition defaultCamera(LatLng coordinates) {
    CameraPosition _camera = CameraPosition(
      target: coordinates,
      bearing: 192.8334901395799,
      tilt: 59.440717697143555,
      zoom: 19.151926040649414,
    );
    return _camera;
  }

  void _onMapCreated(GoogleMapController controller) async {
    List<LatLng> polylineCoordinates = await getDirections();

    setState(() {
      //Create line
      _polylines.add(
        Polyline(
          polylineId: PolylineId("route"),
          points: polylineCoordinates,
          color: Colors.blue,
          width: 4,
          // jointType: JointType.round,
        ),
      );

      //Add markers for every stop
      _markers.add(
        Marker(
          markerId: MarkerId("ctk"),
          position: LatLng(origin.latitude, origin.longitude),
          infoWindow: InfoWindow(title: "Christ the King", snippet: "Departure: 6:30am"),
        ),
      );
      _controller.complete(controller);
      print(getDirections());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(target: LatLng(5.6, -0.17), zoom: 11),

          myLocationEnabled: true,
          myLocationButtonEnabled: false,

          onMapCreated: _onMapCreated,

          markers: _markers,
          polylines: _polylines,
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: _goToCurrentPosition,
            child: const Icon(Icons.my_location_rounded, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Future<void> _goToCurrentPosition() async {
    final GoogleMapController controller = await _controller.future;
    Position position = await determinePosition();
    // 2. Extract coordinates into a LatLng object for the map
    LatLng currentCoords = LatLng(position.latitude, position.longitude);
    await controller.animateCamera(CameraUpdate.newCameraPosition(defaultCamera(currentCoords)));
  }

  Future<List<LatLng>> getDirections() async {
    PolylinePoints polylinePoints = PolylinePoints(apiKey: AppConfig.googleMapsApiKey);

    RoutesApiRequest request = RoutesApiRequest(
      origin: origin,
      destination: destination,
      intermediates: waypoints,
      travelMode: TravelMode.driving,
    );

    RoutesApiResponse response = await polylinePoints.getRouteBetweenCoordinatesV2(
      request: request,
    );

    if (response.routes.isNotEmpty) {
      // Map the PointLatLng to Google Maps LatLng
      return response.routes.first.polylinePoints!
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    }
    return [];
  }

  Widget _buildLocationButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(3), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.my_location_rounded, color: Colors.black87),
        onPressed: () {
          // Logic to recenter map
        },
      ),
    );
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(locationSettings: locationSettings);
  }
}
