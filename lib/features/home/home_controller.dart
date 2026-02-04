import 'package:get/get.dart';
import '../dashboard/dashboard_controller.dart';
import '../../routes/app_pages.dart';

class HomeController extends GetxController {
  
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
