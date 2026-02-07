import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';
import '../services/location_service.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/safe_zone_repository.dart';
import '../../data/repositories/community_repository.dart';
import '../../data/repositories/places_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.put(AuthService(), permanent: true);
    Get.put(FirestoreService(), permanent: true);
    Get.put(StorageService(), permanent: true);
    Get.put(LocationService(), permanent: true);

    // Repositories
    Get.put(AuthRepository(Get.find<AuthService>()), permanent: true);
    Get.put(UserRepository(Get.find<FirestoreService>()), permanent: true);
    Get.put(SafeZoneRepository(Get.find<FirestoreService>()), permanent: true);
    Get.put(CommunityRepository(Get.find<FirestoreService>()), permanent: true);
    Get.put(PlacesRepository(Get.find<FirestoreService>()), permanent: true);
  }
}
