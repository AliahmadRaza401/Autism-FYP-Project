import '../../core/services/firestore_service.dart';
import '../models/safe_zone_model.dart';

class SafeZoneRepository {
  final FirestoreService _firestoreService;

  SafeZoneRepository(this._firestoreService);

  Future<void> addSafeZone(String userId, SafeZoneModel safeZone) async {
    await _firestoreService.setData(
      path: 'users/$userId/safe_zones/${safeZone.id}',
      data: safeZone.toMap(),
    );
  }

  Future<void> deleteSafeZone(String userId, String safeZoneId) async {
    await _firestoreService.deleteData(
      path: 'users/$userId/safe_zones/$safeZoneId',
    );
  }

  Stream<List<SafeZoneModel>> getSafeZones(String userId) {
    return _firestoreService.collectionStream(
      path: 'users/$userId/safe_zones',
      builder: (data, id) => SafeZoneModel.fromMap(data, id),
      sort: (a, b) => b.createdAt.compareTo(a.createdAt),
    );
  }

  Future<void> updateSafeZone(String userId, SafeZoneModel safeZone) async {
    await _firestoreService.updateData(
      path: 'users/$userId/safe_zones/${safeZone.id}',
      data: safeZone.toMap(),
    );
  }
}
