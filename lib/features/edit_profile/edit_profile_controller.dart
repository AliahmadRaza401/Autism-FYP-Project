import 'dart:developer' as dev;
import 'dart:io';

import 'package:bluecircle/core/services/storage_service.dart';
import 'package:bluecircle/core/utils/error_handler.dart';
import 'package:bluecircle/data/models/user_model.dart';
import 'package:bluecircle/data/repositories/auth_repository.dart';
import 'package:bluecircle/data/repositories/user_repository.dart';
import 'package:bluecircle/shared/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shared/utils/image_picker_helper.dart';

class EditProfileController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final UserRepository _userRepository = Get.find<UserRepository>();
  final StorageService _storageService = Get.find<StorageService>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final Rx<File?> profileImage = Rx<File?>(null);
  final RxBool isLoading = false.obs;

  final Rxn<UserModel> user = Rxn<UserModel>();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emergencyController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userId = _authRepository.currentUser?.uid;
    final currentUser = _authRepository.currentUser;
    if (userId == null || currentUser == null) return;

    try {
      isLoading.value = true;
      var userData = await _userRepository.getUser(userId);
      
      if (userData == null) {
        dev.log('User document missing, creating skeleton profile', name: 'EDIT_PROFILE_DEBUG');
        userData = UserModel(
          id: userId,
          name: currentUser.displayName ?? 'New User',
          email: currentUser.email ?? '',
          role: 'parent',
          createdAt: DateTime.now(),
        );
        await _userRepository.createUser(userData);
      }
      
      user.value = userData;

      nameController.text = userData.name;
      emailController.text = userData.email;
      phoneController.text = userData.phone ?? '';
      emergencyController.text = userData.emergencyContact ?? '';

      dev.log('Loaded user data for: ${userData.name}', name: 'EDIT_PROFILE_DEBUG');
    } catch (e) {
      dev.log('Error loading user data: $e', name: 'EDIT_PROFILE_DEBUG');
      // Don't show error snackbar for missing doc if we handle it
      if (!e.toString().contains("does not exist")) {
        ErrorHandler.showErrorSnackBar(e);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    await ImagePickerHelper.showImageSourceSheet(
      onImagePicked: (file) {
        profileImage.value = file;
      },
      onImageRemoved: () {
        profileImage.value = null;
      },
      showRemoveOption: profileImage.value != null || user.value?.profileImage != null,
    );
  }

  Future<void> saveProfile() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // ✅ Validation
    if (name.isEmpty || email.isEmpty) {
      return AppToast.error('Name and Email are required');
    }

    if (!GetUtils.isEmail(email)) {
      return AppToast.error('Invalid Email');
    }

    if (password.isNotEmpty && password.length < 6) {
      return AppToast.error(
          'Password must be at least 6 characters');
    }

    if (password != confirmPassword) {
      return AppToast.error('Passwords do not match');
    }

    try {
      final currentUser = user.value;
      if (currentUser == null) {
        return AppToast.error('User data not loaded yet');
      }

      isLoading.value = true;

      String? imageUrl = currentUser.profileImage;
      String? imagePath = currentUser.profileImageUrl;

      // ✅ Upload new image if selected
      if (profileImage.value != null) {
        final result = await _storageService.uploadImage(
          file: profileImage.value!,
          folder: "users/${currentUser.id}",
        );

        imageUrl = result["url"];
        imagePath = result["path"];
      }

      final updatedUser = currentUser.copyWith(
        name: name,
        email: email,
        phone: phoneController.text.trim(),
        emergencyContact: emergencyController.text.trim(),
        profileImage: imageUrl,
        profileImageUrl: imagePath,
        password: password.isNotEmpty ? password : null,
      );

      await _userRepository.updateUser(updatedUser);

      dev.log('Profile updated successfully',
          name: 'EDIT_PROFILE_DEBUG');

      ErrorHandler.showSuccessSnackBar(
          'Success', 'Profile Updated Successfully');

      Get.back();
    } catch (e) {
      dev.log('Profile update failed: $e',
          name: 'EDIT_PROFILE_DEBUG',
          error: e);

      ErrorHandler.showErrorSnackBar(e);
    } finally {
      isLoading.value = false;
    }
  }
}
