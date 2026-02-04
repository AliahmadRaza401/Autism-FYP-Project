import 'package:get/get.dart';

class ChildSafetyController extends GetxController {
  final RxBool isLocationTrackingEnabled = true.obs;
  final RxBool isSafeZoneAlertsEnabled = true.obs;
  final RxBool isEmergencyContactEnabled = false.obs;

  void toggleLocationTracking(bool value) => isLocationTrackingEnabled.value = value;
  void toggleSafeZoneAlerts(bool value) => isSafeZoneAlertsEnabled.value = value;
  void toggleEmergencyContact(bool value) => isEmergencyContactEnabled.value = value;
}
