import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LiveMapComponent extends StatefulWidget {
  final String journeyId;

  final Function(GoogleMapController)? onControllerCreated;

  const LiveMapComponent({
    super.key,
    required this.journeyId,
    this.onControllerCreated,
  });

  @override
  State<LiveMapComponent> createState() => _LiveMapComponentState();
}

// Added SingleTickerProviderStateMixin for the AnimationController
class _LiveMapComponentState extends State<LiveMapComponent> {
  GoogleMapController? _mapController;
  Marker? _busMarker;
  LatLng _lastPosition = const LatLng(5.7596, -0.2197);

  @override
  void initState() {
    super.initState();
    // Call the async setup
    _setupTracking();
  }

  // Proper way to handle async initialization in initState
  Future<void> _setupTracking() async {
    _subscribeToLiveLocation();
  }

  void _subscribeToLiveLocation() {
    print("📡 Attempting to join channel: journey_${widget.journeyId}");

    final channel = Supabase.instance.client.channel(
      'journey_${widget.journeyId}',
    );

    channel
        .onBroadcast(
          event: 'location_update',
          callback: (payload) {
            print(
              '✅ DATA RECEIVED: $payload',
            ); // This will show in your console

            // Supabase wraps the data in an inner 'payload' object when broadcasting
            final innerData = payload['payload'] ?? {};

            final latRaw = innerData['lat'];
            final lngRaw = innerData['lng'];
            final headingRaw = innerData['heading'] ?? 0.0;

            // Safety checks to handle missing data or type differences
            if (latRaw == null || lngRaw == null) return;

            final double lat = (latRaw is num)
                ? latRaw.toDouble()
                : double.tryParse(latRaw.toString()) ?? 0.0;
            final double lng = (lngRaw is num)
                ? lngRaw.toDouble()
                : double.tryParse(lngRaw.toString()) ?? 0.0;
            final double heading = (headingRaw is num)
                ? headingRaw.toDouble()
                : double.tryParse(headingRaw.toString()) ?? 0.0;

            _updateBusMarker(LatLng(lat, lng), heading);
          },
        )
        .subscribe((status, [error]) {
          // THIS SECTION IS CRITICAL FOR DEBUGGING
          print('📡 Channel Status: $status');
          if (error != null) {
            // We use 'as dynamic' or just print the error directly to avoid the 'Object' error
            print('❌ Supabase Error: ${error.toString()}');
            ;
          }
        });
  }

  void _updateBusMarker(LatLng targetPosition, double rotation) {
    if (mounted) {
      setState(() {
        _lastPosition = targetPosition;

        _busMarker = Marker(
          markerId: const MarkerId('live_bus'),
          position: _lastPosition,
          anchor: const Offset(0.5, 0.5),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        );
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void centerMapOnBus() {
    _mapController?.animateCamera(CameraUpdate.newLatLng(_lastPosition));
  }

  // Simplified map style to reduce OpenGL memory load on Android devices
  final String _mapStyle = '''
  [
    {
      "featureType": "poi",
      "stylers": [
        { "visibility": "off" }
      ]
    },
    {
      "featureType": "transit",
      "stylers": [
        { "visibility": "off" }
      ]
    },
    {
      "featureType": "landscape.man_made",
      "elementType": "geometry.fill",
      "stylers": [
        { "visibility": "off" }
      ]
    }
  ]
  ''';

  @override
  Widget build(BuildContext context) {
    // Removed Scaffold because this is now a Component to be used in a Stack
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: _lastPosition, zoom: 15),
      style: _mapStyle, // Apply performance-focused style
      onMapCreated: (controller) {
        _mapController = controller;

        //Passing controller back up to parent
        if (widget.onControllerCreated != null) {
          widget.onControllerCreated!(controller);
        }
      },
      markers: _busMarker != null ? {_busMarker!} : {},
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false, // Cleaner look for your modular design
    );
  }
}
