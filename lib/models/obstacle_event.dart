class ObstacleEvent {
  final String id;
  final String type; // 'pothole', 'speed_breaker', 'normal'
  final double latitude;
  final double longitude;
  final double accelerationZ;
  final DateTime timestamp;

  ObstacleEvent({
    required this.id,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.accelerationZ,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
      'accelerationZ': accelerationZ,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ObstacleEvent.fromMap(Map<String, dynamic> map) {
    return ObstacleEvent(
      id: map['id'],
      type: map['type'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      accelerationZ: map['accelerationZ'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}