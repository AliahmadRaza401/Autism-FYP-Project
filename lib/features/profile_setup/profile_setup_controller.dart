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

  final childNameController = TextEditingController();
  final dobController = TextEditingController();
  final diagnosisController = TextEditingController();

  
  final Rx<File?> profileImage = Rx<File?>(null);

  
  final RxBool isLoading = false.obs;

  
  final List<String> challenges = ['Social', 'Communication', 'Sensory', 'Behavioral'];
  final RxString selectedChallenge = 'Social'.obs;

  
  final RxDouble noiseSensitivity = 50.0.obs;
  final RxDouble crowdSensitivity = 50.0.obs;
  final RxDouble lightSensitivity = 50.0.obs;

  
  final RxString selectedTextSize = 'medium'.obs;

  
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
    }
  }

  
  Future<String?> uploadProfileImage(String userId) async {
    if (profileImage.value == null) return null;

    try {
      isLoading.value = true;

      final result = await _storageService.uploadImage(
        file: profileImage.value!,
        folder: "users/$userId",
      );

      final imageUrl = result["url"];
      final imagePath = result["path"];

      
      await FirebaseFirestore.instance.collection("users").doc(userId).update({
        "profileImageUrl": imageUrl,
        "profileImagePath": imagePath,
      });

      return imageUrl;
    } catch (e) {
      print("[APP_ERROR] Profile upload error: $e");
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  
  Future<void> saveProfile({
    required String name,
    required String email,
  }) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      Get.snackbar("Error", "User not authenticated");
      return;
    }

    try {
      isLoading.value = true;

      
      final imageUrl = await uploadProfileImage(userId);

      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'name': name,
        'email': email,
        'profileImage': imageUrl ?? '',
      }, SetOptions(merge: true));

      Get.snackbar("Success", "Profile updated successfully!");
    } catch (e) {
      print("[APP_ERROR] Firestore error: $e");
      Get.snackbar("Error", "Failed to save profile.");
    } finally {
      isLoading.value = false;
    }
  }

  
  void setChallenge(String value) {
    selectedChallenge.value = value;
  }

  
  void setTextSize(String value) {
    selectedTextSize.value = value;
  }

  
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

      
      String? imageUrl;
      if (profileImage.value != null) {
        imageUrl = await uploadProfileImage(userId);
      }

      
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

    
      await _userRepository.updateUser(updatedUser);
      ErrorHandler.showSuccessSnackBar(
        "Profile Setup Complete",
        "Your profile has been saved successfully"
      );
    } catch (e) {
      ErrorHandler.showErrorSnackBar(e);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    childNameController.dispose();
    dobController.dispose();
    diagnosisController.dispose();
    super.onClose();
  }
}
