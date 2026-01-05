import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/obstacle_event.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'obstacles';

  // Add new obstacle event
  Future<void> addObstacle(ObstacleEvent event) async {
    try {
      await _firestore.collection(_collection).doc(event.id).set(event.toMap());
    } catch (e) {
      print('Error adding obstacle: $e');
      rethrow;
    }
  }

  // Get all obstacles
  Stream<List<ObstacleEvent>> getObstacles() {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ObstacleEvent.fromMap(doc.data());
      }).toList();
    });
  }

  // Get obstacles by type
  Future<List<ObstacleEvent>> getObstaclesByType(String type) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('type', isEqualTo: type)
        .get();
    
    return snapshot.docs.map((doc) => ObstacleEvent.fromMap(doc.data())).toList();
  }
}