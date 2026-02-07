import 'package:get/get.dart';
import '../dashboard/dashboard_controller.dart';
import '../../routes/app_pages.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/safe_zone_repository.dart';
import '../../data/models/user_model.dart';
import '../../data/models/safe_zone_model.dart';

class HomeController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final UserRepository _userRepository = Get.find<UserRepository>();
  final SafeZoneRepository _safeZoneRepository = Get.find<SafeZoneRepository>();

  final Rxn<UserModel> currentUser = Rxn<UserModel>();
  final RxList<SafeZoneModel> safeZones = <SafeZoneModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchUserData();
  }

  void _fetchUserData() {
    final userId = _authRepository.currentUser?.uid;
    if (userId != null) {
      currentUser.bindStream(_userRepository.userStream(userId));
      safeZones.bindStream(_safeZoneRepository.getSafeZones(userId));
    }
  }

  void goToFindPlaces() {
    Get.find<DashboardController>().changeTabIndex(1);
  }

  void goToCommunity() {
    Get.find<DashboardController>().changeTabIndex(2);
  }

  void goToChildSafety() {
    Get.toNamed(Routes.CHILD_SAFETY);
  }

  void goToProfile() {
    Get.find<DashboardController>().changeTabIndex(3);
  }
}
