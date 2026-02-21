
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/child_model.dart';

class ChildRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'children';

  /// Create a new child profile
  Future<void> createChild(ChildModel child) async {
    await _firestore.collection(_collection).doc(child.childId).set(child.toMap());
  }

  /// Update an existing child profile
  Future<void> updateChild(ChildModel child) async {
    await _firestore.collection(_collection).doc(child.childId).update(child.toMap());
  }

  /// Delete a child profile
  Future<void> deleteChild(String childId) async {
    await _firestore.collection(_collection).doc(childId).delete();
  }

  /// Get a single child by ID
  Future<ChildModel> getChild(String childId) async {
    final doc = await _firestore.collection(_collection).doc(childId).get();
    if (!doc.exists) {
      throw Exception('Child not found');
    }
    return ChildModel.fromMap(doc.data()!, doc.id);
  }

  /// Get all children for a specific parent
  Stream<List<ChildModel>> getChildren(String parentId) {
    return _firestore
        .collection(_collection)
        .where('parentId', isEqualTo: parentId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChildModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  /// Get all children for a specific parent (one-time fetch)
  Future<List<ChildModel>> getChildrenList(String parentId) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('parentId', isEqualTo: parentId)
        .get();
    return snapshot.docs
        .map((doc) => ChildModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  /// Save a place for a child
  Future<void> savePlaceForChild(String childId, String placeId) async {
    await _firestore.collection(_collection).doc(childId).update({
      'savedPlaces': FieldValue.arrayUnion([placeId])
    });
  }

  /// Remove a saved place for a child
  Future<void> removePlaceForChild(String childId, String placeId) async {
    await _firestore.collection(_collection).doc(childId).update({
      'savedPlaces': FieldValue.arrayRemove([placeId])
    });
  }

  /// Check if child email already exists
  Future<bool> childEmailExists(String email) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('childEmail', isEqualTo: email)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  /// Get child by email (for child login validation)
  Future<ChildModel?> getChildByEmail(String email) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('childEmail', isEqualTo: email)
        .get();
    if (snapshot.docs.isEmpty) {
      return null;
    }
    return ChildModel.fromMap(snapshot.docs.first.data(), snapshot.docs.first.id);
  }

  /// Update child profile image
  Future<void> updateChildProfileImage(String childId, String imageUrl, String imagePath) async {
    await _firestore.collection(_collection).doc(childId).update({
      'profileImageUrl': imageUrl,
      'profileImagePath': imagePath,
    });
  }

  /// Update child password
  Future<void> updateChildPassword(String childId, String password) async {
    await _firestore.collection(_collection).doc(childId).update({
      'childPassword': password,
    });
  }
}

