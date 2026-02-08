import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FavoritesRepository {
  final FirebaseFirestore _firestore;

  FavoritesRepository(this._firestore);

  Future<void> toggleFavorite(String userId, String placeId) async {
    final userRef = _firestore.collection('users').doc(userId);
    final userDoc = await userRef.get();
    
    if (!userDoc.exists) return;

    final user = UserModel.fromMap(userDoc.data()!, userDoc.id);
    final favorites = List<String>.from(user.favorites ?? []);

    if (favorites.contains(placeId)) {
      favorites.remove(placeId);
    } else {
      favorites.add(placeId);
    }

    await userRef.update({'favorites': favorites});
  }

  Stream<List<String>> getFavorites(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().map((snapshot) {
      if (!snapshot.exists) return [];
      return List<String>.from(snapshot.data()?['favorites'] ?? []);
    });
  }
}
