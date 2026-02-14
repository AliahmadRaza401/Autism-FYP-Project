import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'categories';

 
  Stream<List<CategoryModel>> getCategories() {
    return _firestore
        .collection(_collection)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CategoryModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<CategoryModel> getCategory(String categoryId) async {
    final doc = await _firestore.collection(_collection).doc(categoryId).get();
    return CategoryModel.fromMap(doc.data()!, doc.id);
  }

  
  Future<void> createCategory(CategoryModel category) async {
    await _firestore.collection(_collection).doc(category.id).set(category.toMap());
  }

  // Update post count
  Future<void> incrementPostCount(String categoryId) async {
    await _firestore.collection(_collection).doc(categoryId).update({
      'postCount': FieldValue.increment(1),
    });
  }

  Future<void> decrementPostCount(String categoryId) async {
    await _firestore.collection(_collection).doc(categoryId).update({
      'postCount': FieldValue.increment(-1),
    });
  }

  // Seed initial categories
  Future<void> seedCategories() async {
    final categories = [
      CategoryModel(
        id: 'quiet_places',
        name: 'Quiet Places',
        icon: '🤫',  // in later you will provide it then added here ok right Mohammad
        createdAt: DateTime.now(),
      ),
      CategoryModel(
        id: 'parent_support',
        name: 'Parent Support',
        icon: '❤️',
        createdAt: DateTime.now(),
      ),
      CategoryModel(
        id: 'sensory_activities',
        name: 'Sensory Activities',
        icon: '🎨',
        createdAt: DateTime.now(),
      ),
      CategoryModel(
        id: 'school_support',
        name: 'School Support',
        icon: '📚',
        createdAt: DateTime.now(),
      ),
      CategoryModel(
        id: 'therapy_tips',
        name: 'Therapy Tips',
        icon: '🧩',
        createdAt: DateTime.now(),
      ),
      CategoryModel(
        id: 'daily_routines',
        name: 'Daily Routines',
        icon: '📅',
        createdAt: DateTime.now(),
      ),
    ];

    final batch = _firestore.batch();
    for (var category in categories) {
      final ref = _firestore.collection(_collection).doc(category.id);
      batch.set(ref, category.toMap(), SetOptions(merge: true));
    }
    await batch.commit();
  }
}
