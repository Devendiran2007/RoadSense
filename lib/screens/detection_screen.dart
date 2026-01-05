import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/sensor_service.dart';
import '../services/classifier_service.dart';
import '../services/firebase_service.dart';
import '../models/obstacle_event.dart';

class DetectionScreen extends StatefulWidget {
  const DetectionScreen({super.key});

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  final SensorService _sensorService = SensorService();
  final ClassifierService _classifier = ClassifierService();
  final FirebaseService _firebaseService = FirebaseService();
  
  bool _isDetecting = false;
  double _currentAcceleration = 9.8;
  int _potholeCount = 0;
  int _speedBreakerCount = 0;

  @override
  void dispose() {
    _sensorService.dispose();
    super.dispose();
  }

  void _startDetection() {
    setState(() {
      _isDetecting = true;
      _potholeCount = 0;
      _speedBreakerCount = 0;
    });

    _sensorService.startSimulation();
    _sensorService.accelerometerStream.listen((accelerationZ) {
      setState(() {
        _currentAcceleration = accelerationZ;
      });

      // Detect obstacles (threshold-based)
      if (accelerationZ > 12.0) {
        _handleObstacleDetection(accelerationZ);
      }
    });
  }

  void _stopDetection() {
    setState(() {
      _isDetecting = false;
    });
    _sensorService.stopSimulation();
  }

  Future<void> _handleObstacleDetection(double accelerationZ) async {
    // Get current location
    Position position = await _getCurrentLocation();
    
    // Classify obstacle
    String type = _classifier.classifyObstacle(accelerationZ);
    
    if (type != 'normal') {
      // Create event
      final event = ObstacleEvent(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: type,
        latitude: position.latitude,
        longitude: position.longitude,
        accelerationZ: accelerationZ,
        timestamp: DateTime.now(),
      );

      // Save to Firebase
      await _firebaseService.addObstacle(event);

      // Update counters
      setState(() {
        if (type == 'pothole') {
          _potholeCount++;
        } else if (type == 'speed_breaker') {
          _speedBreakerCount++;
        }
      });

      // Show feedback
      _showObstacleDetectedSnackbar(type);
    }
  }

  Future<Position> _getCurrentLocation() async {
    // For demo: return simulated location (Chennai area)
    // In production, use: return await Geolocator.getCurrentPosition();
    return Position(
      latitude: 13.0827 + (DateTime.now().millisecond % 100) / 10000,
      longitude: 80.2707 + (DateTime.now().millisecond % 100) / 10000,
      timestamp: DateTime.now(),
      accuracy: 10.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );
  }

  void _showObstacleDetectedSnackbar(String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${type.toUpperCase()} detected!'),
        duration: const Duration(seconds: 1),
        backgroundColor: type == 'pothole' ? Colors.orange : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Detection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Acceleration indicator
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getAccelerationColor(),
                boxShadow: [
                  BoxShadow(
                    color: _getAccelerationColor().withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _currentAcceleration.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'm/s²',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            
            // Statistics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatCard(
                  icon: Icons.warning_amber,
                  label: 'Potholes',
                  count: _potholeCount,
                  color: Colors.orange,
                ),
                _StatCard(
                  icon: Icons.speed,
                  label: 'Speed Breakers',
                  count: _speedBreakerCount,
                  color: Colors.red,
                ),
              ],
            ),
            
            const Spacer(),
            
            // Control button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: _isDetecting ? _stopDetection : _startDetection,
                icon: Icon(_isDetecting ? Icons.stop : Icons.play_arrow, size: 28),
                label: Text(
                  _isDetecting ? 'Stop Detection' : 'Start Detection',
                  style: const TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isDetecting ? Colors.red : Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getAccelerationColor() {
    if (_currentAcceleration < 12.0) {
      return Colors.green;
    } else if (_currentAcceleration < 18.0) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 40),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}