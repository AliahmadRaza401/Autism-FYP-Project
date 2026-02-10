import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/auth_repository.dart';
import '../../core/services/storage_service.dart';
import '../../core/utils/error_handler.dart';

class ProfileSetupController extends GetxController {
  final UserRepository _userRepository = Get.find<UserRepository>();
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final StorageService _storageService = Get.find<StorageService>();

  // Text Controllers
  final childNameController = TextEditingController();
  final dobController = TextEditingController();
  final diagnosisController = TextEditingController();

  // Profile Image
  final Rx<File?> profileImage = Rx<File?>(null);

  // Loading state
  final RxBool isLoading = false.obs;

  // Challenge
  final List<String> challenges = ['Social', 'Communication', 'Sensory', 'Behavioral'];
  final RxString selectedChallenge = 'Social'.obs;

  // Sensory preferences (0 to 100)
  final RxDouble noiseSensitivity = 50.0.obs;
  final RxDouble crowdSensitivity = 50.0.obs;
  final RxDouble lightSensitivity = 50.0.obs;

  // Text size selection
  final RxString selectedTextSize = 'medium'.obs;


  final StorageService storageService = Get.find<StorageService>();

  // Pick image from gallery
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
    }
  }

  // Upload profile image to Firebase Storage
  Future<String?> uploadProfileImage() async {
    if (profileImage.value == null) return null;

    try {
      isLoading.value = true;
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final path = 'users/$userId/profile.jpg';

      final url = await storageService.uploadFile(path: path, file: profileImage.value!);
      isLoading.value = false;
      return url;
    } catch (e) {
      isLoading.value = false;
      print("[APP_ERROR] Storage upload error: $e");
      Get.snackbar("Upload Error", "Failed to upload image.");
      return null;
    }
  }

  // Save profile info to Firestore
  Future<void> saveProfile({
    required String name,
    required String email,
  }) async {
    try {
      isLoading.value = true;
      final userId = FirebaseAuth.instance.currentUser!.uid;

      String? imageUrl = await uploadProfileImage();

      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'name': name,
        'email': email,
        'profileImage': imageUrl ?? '',
      }, SetOptions(merge: true));

      isLoading.value = false;
      Get.snackbar("Success", "Profile updated successfully!");
    } catch (e) {
      isLoading.value = false;
      print("[APP_ERROR] Firestore error: $e");
      Get.snackbar("Error", "Failed to save profile.");
    }
  }
  /// Set selected challenge
  void setChallenge(String value) {
    selectedChallenge.value = value;
  }

  /// Set selected text size
  void setTextSize(String value) {
    selectedTextSize.value = value;
  }

  /// Complete profile setup and save to Firebase
  Future<void> completeSetup() async {
    final userId = _authRepository.currentUser?.uid;
    if (userId == null) {
      ErrorHandler.showErrorSnackBar("User not authenticated");
      return;
    }

    final childName = childNameController.text.trim();
    final dobText = dobController.text.trim();
    final diagnosis = diagnosisController.text.trim();

    if (childName.isEmpty || dobText.isEmpty) {
      ErrorHandler.showErrorSnackBar("Please fill all required fields");
      return;
    }

    final dob = DateTime.tryParse(dobText);
    if (dob == null) {
      ErrorHandler.showErrorSnackBar("Invalid date format");
      return;
    }

    try {
      isLoading.value = true;

      // Upload profile image if selected
      String? imageUrl;
      if (profileImage.value != null) {
        imageUrl = await _storageService.uploadFile(
          path: 'profile_images/$userId.jpg',
          file: profileImage.value!,
        );
      }

      // Prepare user data
      final user = await _userRepository.getUser(userId);
      final updatedUser = user.copyWith(
        childName: childName,
        childDob: dob,
        diagnosis: diagnosis,
        primaryChallenge: selectedChallenge.value,
        profileImage: imageUrl ?? user.profileImage,
        noiseSensitivity: noiseSensitivity.value,
        crowdSensitivity: crowdSensitivity.value,
        lightSensitivity: lightSensitivity.value,
        // textSize: selectedTextSize.value,
      );

      // Update in Firebase
      await _userRepository.updateUser(updatedUser);
      ErrorHandler.showSuccessSnackBar("Profile Setup Complete", "Your profile has been saved successfully");
    } catch (e) {
      ErrorHandler.showErrorSnackBar(e);
    } finally {
      isLoading.value = false;
    }
  }
}
