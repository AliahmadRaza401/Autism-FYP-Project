import 'dart:developer' as dev;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../routes/app_pages.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/auth_repository.dart';
import '../../core/services/storage_service.dart';
import '../../core/utils/error_handler.dart';

class ProfileSetupController extends GetxController {
  final UserRepository _userRepository = Get.find<UserRepository>();
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final StorageService _storageService = Get.find<StorageService>();

  final TextEditingController childNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController diagnosisController = TextEditingController();

  final RxDouble noiseSensitivity = 50.0.obs;
  final RxDouble crowdSensitivity = 50.0.obs;
  final RxDouble lightSensitivity = 50.0.obs;
  final RxString selectedTextSize = "medium".obs;
  final RxString selectedChallenge = 'Social'.obs;
  
  final Rx<File?> profileImage = Rx<File?>(null);
  final RxBool isLoading = false.obs;

  final List<String> challenges = ['Social', 'Communication', 'Sensory', 'Behavioral'];

  @override
  void onInit() {
    super.onInit();
    dev.log('ProfileSetupController Initialized', name: 'PROFILE_SETUP_DEBUG');
  }

  @override
  void onClose() {
    dev.log('ProfileSetupController Closed', name: 'PROFILE_SETUP_DEBUG');
    childNameController.dispose();
    dobController.dispose();
    diagnosisController.dispose();
    super.onClose();
  }

  void setTextSize(String value) {
    selectedTextSize.value = value;
    dev.log('Text size updated: $value', name: 'PROFILE_SETUP_DEBUG');
  }

  void updateNoiseSensitivity(double value) => noiseSensitivity.value = value;
  void updateCrowdSensitivity(double value) => crowdSensitivity.value = value;
  void updateLightSensitivity(double value) => lightSensitivity.value = value;
  
  void setChallenge(String value) {
    selectedChallenge.value = value;
    dev.log('Primary challenge updated: $value', name: 'PROFILE_SETUP_DEBUG');
  }

  Future<void> pickImage() async {
    dev.log('Picking profile image...', name: 'PROFILE_SETUP_DEBUG');
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
      dev.log('Profile image picked: ${pickedFile.path}', name: 'PROFILE_SETUP_DEBUG');
    }
  }

  Future<void> completeSetup() async {
    final userId = _authRepository.currentUser?.uid;
    if (userId == null) {
       dev.log('Setup Failed: No authenticated user found', name: 'PROFILE_SETUP_DEBUG');
       return;
    }

    final childName = childNameController.text.trim();
    final dobText = dobController.text.trim();

    dev.log('Completing setup for user: $userId', name: 'PROFILE_SETUP_DEBUG');

    if (childName.isEmpty) {
      Get.snackbar('Error', "Please enter your child's name");
      return;
    }

    if (dobText.isEmpty) {
      Get.snackbar('Error', "Please enter your child's date of birth");
      return;
    }

    final dobDate = DateTime.tryParse(dobText);
    if (dobDate == null) {
      Get.snackbar('Error', "Please enter a valid date (YYYY-MM-DD)");
      return;
    }

    if (dobDate.isAfter(DateTime.now())) {
      Get.snackbar('Error', "Date of birth cannot be in the future");
      return;
    }

    try {
      isLoading.value = true;

      String? imageUrl;
      if (profileImage.value != null) {
        dev.log('Uploading profile image...', name: 'PROFILE_SETUP_DEBUG');
        imageUrl = await _storageService.uploadFile(
          path: 'profile_images/$userId.jpg',
          file: profileImage.value!,
        );
      }

      final currentUser = await _userRepository.getUser(userId);
      final updatedUser = currentUser.copyWith(
        childName: childName,
        childDob: dobDate,
        diagnosis: diagnosisController.text.trim(),
        noiseSensitivity: noiseSensitivity.value,
        crowdSensitivity: crowdSensitivity.value,
        lightSensitivity: lightSensitivity.value,
        preferredTextSize: selectedTextSize.value,
        primaryChallenge: selectedChallenge.value,
        profileImage: imageUrl ?? currentUser.profileImage,
      );

      await _userRepository.updateUser(updatedUser);
      dev.log('Profile Setup Completed successfully for: $userId', name: 'PROFILE_SETUP_DEBUG');
      ErrorHandler.showSuccessSnackBar('Setup Complete!', 'Your profile has been personalized.');
      Get.toNamed(Routes.SAFE_ZONE);
    } catch (e) {
      dev.log('Profile Setup Failed: $e', name: 'PROFILE_SETUP_DEBUG', error: e);
      ErrorHandler.showErrorSnackBar(e);
    } finally {
      isLoading.value = false;
    }
  }
}
