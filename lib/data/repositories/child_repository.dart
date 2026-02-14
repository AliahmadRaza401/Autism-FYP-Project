import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/child_model.dart';

class ChildRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'children';

  Future<void> createChild(ChildModel child) async {
    await _firestore.collection(_collection).doc(child.childId).set(child.toMap());
  }

  Future<void> updateChild(ChildModel child) async {
    await _firestore.collection(_collection).doc(child.childId).update(child.toMap());
  }

  Future<void> deleteChild(String childId) async {
    await _firestore.collection(_collection).doc(childId).delete();
  }

  Stream<List<ChildModel>> getChildren(String parentId) {
    return _firestore
        .collection(_collection)
        .where('parentId', isEqualTo: parentId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChildModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> savePlaceForChild(String childId, String placeId) async {
    await _firestore.collection(_collection).doc(childId).update({
      'savedPlaces': FieldValue.arrayUnion([placeId])
    });
  }

  Future<void> removePlaceForChild(String childId, String placeId) async {
    await _firestore.collection(_collection).doc(childId).update({
      'savedPlaces': FieldValue.arrayRemove([placeId])
    });
  }
}
