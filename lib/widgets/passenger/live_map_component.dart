import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LiveMapComponent extends StatefulWidget {
  final String journeyId;
  const LiveMapComponent({super.key, required this.journeyId});

  @override
  State<LiveMapComponent> createState() => _LiveMapComponentState();
}

// Added SingleTickerProviderStateMixin for the AnimationController
class _LiveMapComponentState extends State<LiveMapComponent> with SingleTickerProviderStateMixin {
  GoogleMapController? _mapController;
  Marker? _busMarker;
  LatLng _lastPosition = const LatLng(5.7596, -0.2197);

  late AnimationController _animationController;
  BitmapDescriptor? _customIcon;

  @override
  void initState() {
    super.initState();

    // Initialize the controller first
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Call the async setup
    _setupTracking();
  }

  // Proper way to handle async initialization in initState
  Future<void> _setupTracking() async {
    await _loadCustomIcon();
    _subscribeToLiveLocation();
  }

  // Modern way to load map assets (replacing deprecated fromAssetImage)
  Future<void> _loadCustomIcon() async {
    final icon = await AssetMapBitmap.create(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/bus_top_view.png',
    );
    if (mounted) {
      setState(() => _customIcon = icon);
    }
  }

  void _subscribeToLiveLocation() {
    Supabase.instance.client
        .channel('journey_${widget.journeyId}')
        .onBroadcast(
          event: 'location_update',
          callback: (payload) {
            final double lat = payload['lat'];
            final double lng = payload['lng'];
            final double heading = (payload['heading'] ?? 0.0).toDouble();

            _updateBusMarker(LatLng(lat, lng), heading);
          },
        )
        .subscribe();
  }

  void _updateBusMarker(LatLng targetPosition, double rotation) {
    // Kill existing listeners to prevent multiple tweens fighting
    _animationController.stop();
    _animationController.clearListeners();

    final latTween = Tween<double>(begin: _lastPosition.latitude, end: targetPosition.latitude);
    final lngTween = Tween<double>(begin: _lastPosition.longitude, end: targetPosition.longitude);

    _animationController.addListener(() {
      if (mounted) {
        setState(() {
          _lastPosition = LatLng(
            latTween.evaluate(_animationController),
            lngTween.evaluate(_animationController),
          );

          _busMarker = Marker(
            markerId: const MarkerId('live_bus'),
            position: _lastPosition,
            rotation: rotation,
            flat: true,
            anchor: const Offset(0.5, 0.5),
            icon: _customIcon ?? BitmapDescriptor.defaultMarker,
          );
        });
      }
    });

    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Removed Scaffold because this is now a Component to be used in a Stack
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: _lastPosition, zoom: 15),
      onMapCreated: (controller) => _mapController = controller,
      markers: _busMarker != null ? {_busMarker!} : {},
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false, // Cleaner look for your modular design
    );
  }
}
