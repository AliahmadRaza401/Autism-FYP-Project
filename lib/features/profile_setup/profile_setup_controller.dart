import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';

class ProfileSetupController extends GetxController {
  final TextEditingController childNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController diagnosisController = TextEditingController();

  final RxDouble noiseSensitivity = 50.0.obs;
  final RxDouble crowdSensitivity = 50.0.obs;
  final RxDouble lightSensitivity = 50.0.obs;
  final RxString selectedTextSize = "medium".obs;

void setTextSize(String value) {
  selectedTextSize.value = value;
}

  
  final RxString selectedChallenge = 'Social'.obs;
  final List<String> challenges = ['Social', 'Communication', 'Sensory', 'Behavioral'];

  void updateNoiseSensitivity(double value) => noiseSensitivity.value = value;
  void updateCrowdSensitivity(double value) => crowdSensitivity.value = value;
  void updateLightSensitivity(double value) => lightSensitivity.value = value;
  
  void setChallenge(String value) => selectedChallenge.value = value;

  void completeSetup() {
    Get.offAllNamed(Routes.DASHBOARD); // Or Safe Zone if that's next in flow, user said Safe Zone next
    // Based on "Screens to Build": Profile Setup -> Set Safe Zone -> Home
    // So let's route to Safe Zone eventually, but for now let's stick to the list order or just Home.
    // User list: Splash -> Onboarding -> Auth -> Profile Setup -> Safe Zone -> Home
    // So next is Safe Zone.
    // I need to add Safe Zone route first. 
    // For now, let's route to Safe Zone placeholder, check routes.
    // I haven't added SAFE_ZONE route yet. Will add it in next step.
    Get.toNamed(Routes.SAFE_ZONE); 
  }
}
