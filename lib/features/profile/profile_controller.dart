import 'package:get/get.dart';
import '../../routes/app_pages.dart';

class ProfileController extends GetxController {
  
  void onEditProfileTap() {
    Get.toNamed(Routes.EDIT_PROFILE);
  }

  void onLogout() {
    Get.offAllNamed(Routes.SIGN_IN);
  }
}
