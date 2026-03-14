import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:driver_app/widgets/passenger/live_map_component.dart';

// Dummy model for demonstration
class _RouteData {
  final String routeName;
  final String status;
  final int passengerCount;
  final int capacity;

  _RouteData({
    required this.routeName,
    required this.status,
    required this.passengerCount,
    required this.capacity,
  });
}

class TrackTab extends StatefulWidget {
  const TrackTab({super.key});

  @override
  State<TrackTab> createState() => _TrackTabState();
}

class _TrackTabState extends State<TrackTab> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  
  final List<_RouteData> _activeRoutes = [
    _RouteData(
        routeName: "Route 402 - Main Campus",
        status: "Live",
        passengerCount: 32,
        capacity: 45),
    _RouteData(
        routeName: "Route 105 - Accra Mall",
        status: "Delayed",
        passengerCount: 40,
        capacity: 45),
    _RouteData(
        routeName: "Route 311 - Madina",
        status: "Live",
        passengerCount: 12,
        capacity: 30),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. THE MAP (Base Layer)
          const Positioned.fill(child: LiveMapComponent(journeyId: "bus-402-demo")),

          // 2. SLIDABLE ROUTE CAROUSEL (Top overlay)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 0,
            right: 0,
            height: 100, // Fixed height for the routing cards
            child: PageView.builder(
              controller: _pageController,
              itemCount: _activeRoutes.length,
              itemBuilder: (context, index) {
                return _buildRouteCard(_activeRoutes[index]);
              },
            ),
          ),
          
          // 3. RE-CENTER LOCATION BUTTON (Floating above the bottom nav)
          Positioned(
            bottom: 40,
            right: 20,
            child: _buildLocationButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteCard(_RouteData route) {
    bool isLive = route.status.toLowerCase() == "live";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                // Bus Icon Left
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC62828).withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.directions_bus_rounded,
                    color: Color(0xFFC62828),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Route Details Middle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        route.routeName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (isLive) ...[
                            const _PulsatingDot(color: Colors.green),
                            const SizedBox(width: 6),
                          ] else ...[
                            const Icon(Icons.circle, color: Colors.orange, size: 8),
                            const SizedBox(width: 6),
                          ],
                          Text(
                            route.status,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isLive ? Colors.green.shade700 : Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Passenger Info Right
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.people_alt, size: 16, color: Colors.black54),
                      const SizedBox(height: 4),
                      Text(
                        "${route.passengerCount}/${route.capacity}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
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
}

// A simple pulsating dot widget
class _PulsatingDot extends StatefulWidget {
  final Color color;
  const _PulsatingDot({required this.color});

  @override
  State<_PulsatingDot> createState() => _PulsatingDotState();
}

class _PulsatingDotState extends State<_PulsatingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: 0.3 + (_controller.value * 0.7),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(0.5 * _controller.value),
                  blurRadius: 6 * _controller.value,
                  spreadRadius: 2 * _controller.value,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
