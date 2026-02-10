

import 'dart:developer' as dev;

import 'package:autismcare/core/utils/error_handler.dart';
import 'package:autismcare/data/models/user_model.dart';
import 'package:autismcare/data/repositories/auth_repository.dart';
import 'package:autismcare/data/repositories/user_repository.dart';
import 'package:autismcare/routes/app_pages.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ProfileController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final UserRepository _userRepository = Get.find<UserRepository>();

  final Rxn<UserModel> user = Rxn<UserModel>();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  void _loadUser() {
    final userId = _authRepository.currentUser?.uid;
    if (userId != null) {
      user.bindStream(_userRepository.userStream(userId));
      dev.log('User stream bound for $userId', name: 'PROFILE_DEBUG');
    }
  }

  void onEditProfileTap() => Get.toNamed(Routes.EDIT_PROFILE);

  Future<void> onLogout() async {
    try {
      isLoading.value = true;
      await _authRepository.signOut();
      Get.offAllNamed(Routes.SIGN_IN);
      dev.log('User logged out', name: 'PROFILE_DEBUG');
    } catch (e) {
      dev.log('Logout failed: $e', name: 'PROFILE_DEBUG', error: e);
      ErrorHandler.showErrorSnackBar(e);
    } finally {
      isLoading.value = false;
    }
  }
}
