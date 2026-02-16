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
import 'package:image_picker/image_picker.dart';

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

  late UserModel _user;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userId = _authRepository.currentUser?.uid;
    if (userId == null) return;

    try {
      _user = await _userRepository.getUser(userId);

      nameController.text = _user.name;
      emailController.text = _user.email ?? '';

      dev.log('Loaded user data', name: 'EDIT_PROFILE_DEBUG');
    } catch (e) {
      ErrorHandler.showErrorSnackBar(e);
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
    }
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
      isLoading.value = true;

      String? imageUrl = _user.profileImage;
      String? imagePath = _user.profileImageUrl;

      // ✅ Upload new image if selected
      if (profileImage.value != null) {
        final result = await _storageService.uploadImage(
          file: profileImage.value!,
          folder: "users/${_user.id}",
        );

        imageUrl = result["url"];
        imagePath = result["path"];
      }

      final updatedUser = _user.copyWith(
        name: name,
        email: email,
        profileImage: imageUrl,
        profileImageUrl: imagePath,
        password:
            password.isNotEmpty ? password : null,
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
