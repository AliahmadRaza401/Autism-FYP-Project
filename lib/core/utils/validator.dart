import 'package:get/get_utils/src/get_utils/get_utils.dart';

class Validator {
  static String? validateEmail(String email) {
    if (email.isEmpty) return "Email is required";
    if (!GetUtils.isEmail(email)) return "Invalid email format";
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) return "Password is required";
    if (password.length < 8) return "Password must be at least 8 characters";
    if (!RegExp(r'[A-Z]').hasMatch(password)) return "Password must contain at least one uppercase letter";
    if (!RegExp(r'[a-z]').hasMatch(password)) return "Password must contain at least one lowercase letter";
    if (!RegExp(r'\d').hasMatch(password)) return "Password must contain at least one number";
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) return "Password must contain at least one special character";
    return null;
  }

  static String? validateSignInPassword(String password) {
    if (password.isEmpty) return "Password is required";
    return null;
  }

  static String? validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) return "Please confirm your password";
    if (confirmPassword != password) return "Passwords do not match";
    return null;
  }

  static String? validateName(String name) {
    if (name.isEmpty) return "Name is required";
    if (name.length < 2) return "Name too short";
    return null;
  }

  static String? validatePhoneNumber(String phone) {
    if (phone.isEmpty) return "Phone number is required";

    final sanitizedPhone = phone.replaceAll(RegExp(r'[\s()-]'), '');
    if (!RegExp(r'^\+[1-9]\d{9,14}$').hasMatch(sanitizedPhone)) {
      return "Enter phone number with country code, e.g. +923001234567";
    }

    return null;
  }

  static String? validateOtpCode(String code) {
    if (code.isEmpty) return "OTP code is required";
    if (!RegExp(r'^\d{6}$').hasMatch(code)) {
      return "Enter the 6-digit OTP code";
    }
    return null;
  }
}
