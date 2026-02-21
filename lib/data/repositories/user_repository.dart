import '../models/user_model.dart';
import '../../core/services/firestore_service.dart';

class UserRepository {
  final FirestoreService _firestoreService;

  UserRepository(this._firestoreService);

  Future<void> createUser(UserModel user) async {
    await _firestoreService.setData(
      path: 'users/${user.id}',
      data: user.toMap(),
    );
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      return await _firestoreService.getDocument(
        path: 'users/$userId',
        builder: (data, id) => UserModel.fromMap(data, id),
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUser(UserModel user) async {
    await _firestoreService.updateData(
      path: 'users/${user.id}',
      data: user.toMap(),
    );
  }

  Stream<UserModel> userStream(String userId) {
    return _firestoreService.documentStream(
      path: 'users/$userId',
      builder: (data, id) => UserModel.fromMap(data, id),
    );
  }
}
