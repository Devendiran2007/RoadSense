import 'dart:async';
import 'dart:math';

class SensorService {
  final _controller = StreamController<double>.broadcast();
  Timer? _timer;
  final Random _random = Random();

  Stream<double> get accelerometerStream => _controller.stream;

  // Simulate driving with occasional jolts
  void startSimulation() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      double baselineZ = 9.8; // Normal gravity
      
      // Randomly generate jolts (10% chance)
      if (_random.nextDouble() < 0.1) {
        // Simulate a jolt (pothole or speed breaker)
        double joltMagnitude = 15.0 + _random.nextDouble() * 10.0; // 15-25 m/s²
        _controller.add(joltMagnitude);
      } else {
        // Normal road noise
        double noise = baselineZ + (_random.nextDouble() - 0.5) * 2.0;
        _controller.add(noise);
      }
    });
  }

  void stopSimulation() {
    _timer?.cancel();
  }

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}