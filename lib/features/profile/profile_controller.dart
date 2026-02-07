import 'package:get/get.dart';
import '../../routes/app_pages.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/models/user_model.dart';
import '../../core/utils/error_handler.dart';

class ProfileController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final UserRepository _userRepository = Get.find<UserRepository>();

  final Rxn<UserModel> user = Rxn<UserModel>();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchUserData();
  }

  void _fetchUserData() {
    final userId = _authRepository.currentUser?.uid;
    if (userId != null) {
      user.bindStream(_userRepository.userStream(userId));
    }
  }
  
  void onEditProfileTap() {
    Get.toNamed(Routes.EDIT_PROFILE);
  }

  Future<void> onLogout() async {
    try {
      await _authRepository.signOut();
      Get.offAllNamed(Routes.SIGN_IN);
    } catch (e) {
      ErrorHandler.showErrorSnackBar(e);
    }
  }
}
