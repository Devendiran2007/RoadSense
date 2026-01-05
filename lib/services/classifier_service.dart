class ClassifierService {
  // Simple rule-based classification
  // In a real app, this would use TensorFlow Lite
  String classifyObstacle(double accelerationZ) {
    if (accelerationZ < 12.0) {
      return 'normal';
    } else if (accelerationZ >= 12.0 && accelerationZ < 18.0) {
      return 'pothole';
    } else {
      return 'speed_breaker';
    }
  }

  // Placeholder for TensorFlow integration
  // Future<String> classifyWithML(List<double> sensorData) async {
  //   // Load TFLite model
  //   // Run inference
  //   // Return prediction
  // }
}