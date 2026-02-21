import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/child_model.dart';

class ChildRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'children';

  Future<void> createChild(String parentId, ChildModel child) async {
    final docRef = _firestore.collection(_collection).doc(child.childId);

    final newChild = child.copyWith(
      parentId: parentId,
      createdAt: DateTime.now(),
    );

    await docRef.set(newChild.toMap());
  }

  /// 🔹 Update child
  Future<void> updateChild(ChildModel child) async {
    await _firestore
        .collection(_collection)
        .doc(child.childId)
        .update(child.toMap());
  }

  /// 🔹 Delete child
  Future<void> deleteChild(String childId) async {
    await _firestore.collection(_collection).doc(childId).delete();
  }

Stream<List<ChildModel>> getChildren(String parentId) {
  return _firestore
      .collection('children')
      .where('parentId', isEqualTo: parentId)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) =>
              ChildModel.fromMap(doc.data(), doc.id)
          ).toList());
}
  /// 🔹 One time fetch
  Future<List<ChildModel>> getChildrenList(String parentId) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('parentId', isEqualTo: parentId)
        .get();

    return snapshot.docs
        .map((doc) => ChildModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  /// 🔹 Get single child
  Future<ChildModel> getChild(String childId) async {
    final doc = await _firestore.collection(_collection).doc(childId).get();

    if (!doc.exists) {
      throw Exception('Child not found');
    }

    return ChildModel.fromMap(doc.data()!, doc.id);
  }

  /// 🔹 Save place
  Future<void> savePlaceForChild(String childId, String placeId) async {
    await _firestore.collection(_collection).doc(childId).update({
      'savedPlaces': FieldValue.arrayUnion([placeId])
    });
  }

  /// 🔹 Remove saved place
  Future<void> removePlaceForChild(String childId, String placeId) async {
    await _firestore.collection(_collection).doc(childId).update({
      'savedPlaces': FieldValue.arrayRemove([placeId])
    });
  }

  /// 🔹 Check email exists
  Future<bool> childEmailExists(String email) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('childEmail', isEqualTo: email)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  /// 🔹 Get by email
  Future<ChildModel?> getChildByEmail(String email) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('childEmail', isEqualTo: email)
        .get();

    if (snapshot.docs.isEmpty) return null;

    return ChildModel.fromMap(
        snapshot.docs.first.data(),
        snapshot.docs.first.id);
  }

  /// 🔹 Update profile image
  Future<void> updateChildProfileImage(
      String childId,
      String imageUrl,
      String imagePath) async {

    await _firestore.collection(_collection).doc(childId).update({
      'profileImageUrl': imageUrl,
      'profileImagePath': imagePath,
    });
  }

  /// 🔹 Update password
  Future<void> updateChildPassword(String childId, String password) async {
    await _firestore.collection(_collection).doc(childId).update({
      'childPassword': password,
    });
  }
}