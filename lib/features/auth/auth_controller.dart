import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';

class AuthController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  
  final RxBool isPasswordVisible = false.obs;
  final RxBool isRememberMe = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe(bool? value) {
    if (value != null) {
      isRememberMe.value = value;
    }
  }

  void signIn() {

        Get.offAllNamed(Routes.DASHBOARD);
  }

  void signUp() {
    Get.offNamed(Routes.PROFILE_SETUP);
  }
}
