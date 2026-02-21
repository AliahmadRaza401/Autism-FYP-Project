import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/place_model.dart';
import '../models/review_model.dart';

class PlacesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'places';

  Stream<List<PlaceModel>> getPlaces({
    String? category,
    double? minNoise,
    double? minCrowd,
    double? minLight,
    double? minRating,
  }) {
    Query query = _firestore.collection(_collection);

    if (category != null && category != 'All') {
      query = query.where('category', isEqualTo: category);
    }

    if (minRating != null) {
      query = query.where('overallRating', isGreaterThanOrEqualTo: minRating);
    }

    if (minNoise != null) query = query.where('sensoryRatings.noise', isGreaterThanOrEqualTo: minNoise);
    if (minCrowd != null) query = query.where('sensoryRatings.crowd', isGreaterThanOrEqualTo: minCrowd);
    if (minLight != null) query = query.where('sensoryRatings.light', isGreaterThanOrEqualTo: minLight);

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => PlaceModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList());
  }

  Future<PlaceModel> getPlaceById(String placeId) async {
    final doc = await _firestore.collection(_collection).doc(placeId).get();
    return PlaceModel.fromMap(doc.data()!, doc.id);
  }

  // Reviews System ok Mohammad right
  Future<void> addReview(ReviewModel review) async {
    final batch = _firestore.batch();
    
    final reviewRef = _firestore.collection('reviews').doc();
    batch.set(reviewRef, review.toMap());

    final placeRef = _firestore.collection(_collection).doc(review.postId);
    batch.update(placeRef, {
      'reviewCount': FieldValue.increment(1),
    });

    await batch.commit();
  }

  Stream<List<ReviewModel>> getReviews(String placeId) {
    return _firestore
        .collection('reviews')
        .where('postId', isEqualTo: placeId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReviewModel.fromMap(doc.data(), doc.id))
            .toList());
  }


  Future<void> savePlace(String userId, String placeId, {String? childId}) async {
    await _firestore.collection('savedPlaces').add({
      'userId': userId,
      'placeId': placeId,
      'childId': childId,
      'savedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> createPlace(PlaceModel place) async {
    await _firestore.collection(_collection).doc(place.id).set(place.toMap());
  }
}
