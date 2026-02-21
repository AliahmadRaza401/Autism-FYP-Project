import 'package:bluecircle/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  var tabIndex = 0.obs;

  String get fabLabel {
    switch (tabIndex.value) {
      case 1: return "Create Place";
      case 2: return "Create Post";
      default: return "My Children";
    }
  }

  IconData get fabIcon {
    switch (tabIndex.value) {
      case 1: return Icons.add_location_alt;
      case 2: return Icons.add;
      default: return Icons.child_care;
    }
  }

  bool get showFab => tabIndex.value != 3;

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  void onFabPressed() {
    switch (tabIndex.value) {
      case 0:
        Get.toNamed(Routes.CHILDREN_MANAGEMENT);
        break;
      case 1:
        Get.toNamed(Routes.PLACE_CREATION);
        break;
      case 2:
        Get.toNamed(Routes.POST_CREATION);
        break;
    }
  }
}
