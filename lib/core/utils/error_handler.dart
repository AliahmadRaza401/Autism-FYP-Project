import 'dart:developer' as dev;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';

class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'Invalid email or password.';
        case 'email-already-in-use':
          return 'This email is already registered.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'weak-password':
          return 'Your password is too weak.';
        case 'operation-not-allowed':
          return 'Login method not allowed. Contact support.';
        case 'too-many-requests':
          return 'Too many requests. Please try again later.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection.';
        case 'user-disabled':
          return 'This user account has been disabled.';
        default:
          return error.message ?? 'An unknown authentication error occurred.';
      }
    } else if (error is FirebaseException) {
      if (error.code == 'permission-denied') {
        return 'You do not have permission to perform this action.';
      }
      return error.message ?? 'A database error occurred.';
    } else {
      final errorString = error.toString();
      if (errorString.contains('No AppCheckProvider installed')) {
        return 'App Check error. Please ensure the app is properly configured.';
      }
      return errorString;
    }
  }

  static void showErrorSnackBar(dynamic error) {
    final message = getErrorMessage(error);
    
   
    dev.log(
      'ERROR: $message', 
      name: 'APP_ERROR', 
      error: error,
      level: 1000, 
    );

    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.error.withValues(alpha: 0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      duration: const Duration(seconds: 4),
    );
  }

  static void showSuccessSnackBar(String title, String message) {
    dev.log(
      'SUCCESS: $message', 
      name: 'APP_SUCCESS',
      level: 0,
    );

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.success.withValues(alpha: 0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }
}
