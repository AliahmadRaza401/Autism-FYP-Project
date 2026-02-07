import 'dart:developer' as dev;
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../core/services/storage_service.dart';
import '../../data/models/user_model.dart';
import '../../core/utils/error_handler.dart';

class EditProfileController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final UserRepository _userRepository = Get.find<UserRepository>();
  final StorageService _storageService = Get.find<StorageService>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController childNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  
  final Rx<File?> profileImage = Rx<File?>(null);
  final RxBool isLoading = false.obs;
  
  late UserModel _user;

  @override
  void onInit() {
    super.onInit();
    dev.log('EditProfileController Initialized', name: 'EDIT_PROFILE_DEBUG');
    _loadUserData();
  }

  @override
  void onClose() {
    dev.log('EditProfileController Closed', name: 'EDIT_PROFILE_DEBUG');
    nameController.dispose();
    emailController.dispose();
    childNameController.dispose();
    dobController.dispose();
    super.onClose();
  }

  Future<void> _loadUserData() async {
    final userId = _authRepository.currentUser?.uid;
    if (userId == null) return;

    try {
      dev.log('Loading user data for: $userId', name: 'EDIT_PROFILE_DEBUG');
      _user = await _userRepository.getUser(userId);
      nameController.text = _user.name;
      emailController.text = _user.email;
      childNameController.text = _user.childName ?? '';
      dobController.text = _user.childDob?.toString().split(' ')[0] ?? '';
    } catch (e) {
      dev.log('Error loading user data: $e', name: 'EDIT_PROFILE_DEBUG', error: e);
      ErrorHandler.showErrorSnackBar(e);
    }
  }

  Future<void> pickImage() async {
    dev.log('Picking profile image...', name: 'EDIT_PROFILE_DEBUG');
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
      dev.log('Profile image updated locally: ${pickedFile.path}', name: 'EDIT_PROFILE_DEBUG');
    }
  }

  Future<void> saveProfile() async {
    final userId = _authRepository.currentUser?.uid;
    if (userId == null) return;

    final name = nameController.text.trim();
    final childName = childNameController.text.trim();
    final dobText = dobController.text.trim();

    dev.log('Saving profile for: $userId', name: 'EDIT_PROFILE_DEBUG');

    if (name.isEmpty || childName.isEmpty) {
      Get.snackbar('Error', 'Name and Child Name cannot be empty');
      return;
    }

    DateTime? dobDate;
    if (dobText.isNotEmpty) {
      dobDate = DateTime.tryParse(dobText);
      if (dobDate == null) {
        Get.snackbar('Error', 'Invalid date format (YYYY-MM-DD)');
        return;
      }
      if (dobDate.isAfter(DateTime.now())) {
        Get.snackbar('Error', 'Date of birth cannot be in the future');
        return;
      }
    }

    try {
      isLoading.value = true;

      String? imageUrl;
      if (profileImage.value != null) {
        dev.log('Uploading new profile image...', name: 'EDIT_PROFILE_DEBUG');
        imageUrl = await _storageService.uploadFile(
          path: 'profile_images/$userId.jpg',
          file: profileImage.value!,
        );
      }

      final updatedUser = _user.copyWith(
        name: name,
        childName: childName,
        childDob: dobDate ?? _user.childDob,
        profileImage: imageUrl ?? _user.profileImage,
      );

      await _userRepository.updateUser(updatedUser);
      dev.log('Profile saved successfully for: $userId', name: 'EDIT_PROFILE_DEBUG');
      
      ErrorHandler.showSuccessSnackBar('Success', 'Profile Updated Successfully');
      Get.back();
    } catch (e) {
      dev.log('Error saving profile: $e', name: 'EDIT_PROFILE_DEBUG', error: e);
      ErrorHandler.showErrorSnackBar(e);
    } finally {
      isLoading.value = false;
    }
  }
}
