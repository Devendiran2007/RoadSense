import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/firebase_service.dart';
import '../models/obstacle_event.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  
  // Default location: Chennai
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(13.0827, 80.2707),
    zoom: 13,
  );

  @override
  void initState() {
    super.initState();
    _loadObstacles();
  }

  void _loadObstacles() {
    _firebaseService.getObstacles().listen((obstacles) {
      setState(() {
        _markers = obstacles.map((obstacle) {
          return Marker(
            markerId: MarkerId(obstacle.id),
            position: LatLng(obstacle.latitude, obstacle.longitude),
            icon: _getMarkerIcon(obstacle.type),
            infoWindow: InfoWindow(
              title: obstacle.type.toUpperCase(),
              snippet: 'Detected: ${_formatTime(obstacle.timestamp)}',
            ),
          );
        }).toSet();
      });
    });
  }

  BitmapDescriptor _getMarkerIcon(String type) {
    // In a real app, use custom marker icons
    return type == 'pothole' 
        ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange)
        : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Obstacle Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadObstacles,
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            markers: _markers,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          
          // Legend
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Legend',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _LegendItem(
                    color: Colors.orange,
                    label: 'Pothole',
                  ),
                  _LegendItem(
                    color: Colors.red,
                    label: 'Speed Breaker',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}