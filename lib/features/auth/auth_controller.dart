import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/models/user_model.dart';
import '../../core/utils/error_handler.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final UserRepository _userRepository = Get.find<UserRepository>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  
  final RxBool isPasswordVisible = false.obs;
  final RxBool isRememberMe = false.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    dev.log('AuthController Initialized', name: 'AUTH_DEBUG');
  }

  @override
  void onClose() {
    dev.log('AuthController Closed', name: 'AUTH_DEBUG');
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe(bool? value) {
    if (value != null) {
      isRememberMe.value = value;
    }
  }

  Future<void> signIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    dev.log('Attempting Sign-In for: $email', name: 'AUTH_DEBUG');

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Error', 'Please enter a valid email address');
      return;
    }

    if (password.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters long');
      return;
    }

    try {
      isLoading.value = true;
      await _authRepository.signIn(email, password);
      
      dev.log('Sign-In Successful: $email', name: 'AUTH_DEBUG');
      ErrorHandler.showSuccessSnackBar('Welcome Back!', 'You have successfully signed in.');
      Get.offAllNamed(Routes.DASHBOARD);
    } catch (e) {
      dev.log('Sign-In Failed: $e', name: 'AUTH_DEBUG', error: e);
      ErrorHandler.showErrorSnackBar(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final name = nameController.text.trim();

    dev.log('Attempting Sign-Up for: $email', name: 'AUTH_DEBUG');

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }

    if (name.length < 2) {
      Get.snackbar('Error', 'Name must be at least 2 characters long');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Error', 'Please enter a valid email address');
      return;
    }

    if (password.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters long');
      return;
    }

    try {
      isLoading.value = true;
      final userCredential = await _authRepository.signUp(email, password);

      if (userCredential.user != null) {
        final newUser = UserModel(
          id: userCredential.user!.uid,
          name: name,
          email: email,
          createdAt: DateTime.now(),
        );
        await _userRepository.createUser(newUser);
        
        dev.log('Sign-Up Successful: $email', name: 'AUTH_DEBUG');
        ErrorHandler.showSuccessSnackBar('Welcome!', 'Your account has been created successfully.');
        Get.offNamed(Routes.PROFILE_SETUP);
      }
    } catch (e) {
      dev.log('Sign-Up Failed: $e', name: 'AUTH_DEBUG', error: e);
      ErrorHandler.showErrorSnackBar(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    dev.log('User Logging Out', name: 'AUTH_DEBUG');
    try {
      await _authRepository.signOut();
      Get.offAllNamed(Routes.SIGN_IN);
    } catch (e) {
      dev.log('Logout Failed: $e', name: 'AUTH_DEBUG', error: e);
      ErrorHandler.showErrorSnackBar(e);
    }
  }
}
