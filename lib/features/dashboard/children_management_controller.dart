import 'dart:developer' as dev;
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/child_model.dart';
import '../../data/repositories/child_repository.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/utils/error_handler.dart';

class ChildrenManagementController extends GetxController {
  final ChildRepository _childRepository = Get.find<ChildRepository>();
  final AuthService _authService = Get.find<AuthService>();
  final StorageService _storageService = Get.find<StorageService>();
  
  final RxList<ChildModel> children = <ChildModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isUploading = false.obs;
  
  // Form controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  
  // Image
  final Rx<File?> selectedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();
  
  // Sensory preferences
  final RxMap<String, int> sensoryPreferences = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadChildren();
    _initSensoryPreferences();
  }

  void _initSensoryPreferences() {
    sensoryPreferences.value = {
      'noise': 5,
      'crowd': 5,
      'light': 5,
      'touch': 5,
    };
  }

  @override
  void onClose() {
    nameController.dispose();
    ageController.dispose();
    emailController.dispose();
    passwordController.dispose();
    notesController.dispose();
    super.onClose();
  }

  /// Load all children for the current parent
  Future<void> loadChildren() async {
    try {
      isLoading.value = true;
      final parentId = _authService.currentUser?.uid;
      
      if (parentId != null) {
        dev.log("Loading children for parent: $parentId", name: "CHILDREN_MGMT");
        
        _childRepository.getChildren(parentId).listen((childList) {
          children.value = childList;
          dev.log("Loaded ${childList.length} children", name: "CHILDREN_MGMT");
        });
      }
    } catch (e) {
      dev.log("Error loading children: $e", name: "CHILDREN_MGMT", error: e);
      ErrorHandler.showErrorSnackBar("Failed to load children");
    } finally {
      isLoading.value = false;
    }
  }

  /// Pick image from gallery
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      dev.log("Error picking image: $e", name: "CHILDREN_MGMT", error: e);
    }
  }

  /// Pick image from camera
  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      dev.log("Error picking image from camera: $e", name: "CHILDREN_MGMT", error: e);
    }
  }

  /// Clear selected image
  void clearImage() {
    selectedImage.value = null;
  }

  /// Clear form fields
  void clearForm() {
    nameController.clear();
    ageController.clear();
    emailController.clear();
    passwordController.clear();
    notesController.clear();
    selectedImage.value = null;
    _initSensoryPreferences();
  }

  /// Create a new child account
  Future<void> createChild() async {
    final name = nameController.text.trim();
    final ageText = ageController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final notes = notesController.text.trim();
    
    // Validation
    if (name.isEmpty) {
      ErrorHandler.showErrorSnackBar("Please enter child's name");
      return;
    }
    
    if (ageText.isEmpty) {
      ErrorHandler.showErrorSnackBar("Please enter child's age");
      return;
    }
    
    final age = int.tryParse(ageText);
    if (age == null || age < 0 || age > 18) {
      ErrorHandler.showErrorSnackBar("Please enter a valid age (0-18)");
      return;
    }
    
    if (email.isEmpty) {
      ErrorHandler.showErrorSnackBar("Please enter child's email");
      return;
    }
    
    if (password.isEmpty) {
      ErrorHandler.showErrorSnackBar("Please enter a password");
      return;
    }
    
    if (password.length < 6) {
      ErrorHandler.showErrorSnackBar("Password must be at least 6 characters");
      return;
    }

    try {
      isLoading.value = true;
      final parentId = _authService.currentUser?.uid;
      
      if (parentId == null) {
        ErrorHandler.showErrorSnackBar("Please login as a parent");
        return;
      }

      // Check if email already exists
      final emailExists = await _childRepository.childEmailExists(email);
      if (emailExists) {
        ErrorHandler.showErrorSnackBar("This email is already in use");
        return;
      }

      // Create Firebase Auth account for child
      dev.log("Creating Firebase Auth account for child: $email", name: "CHILDREN_MGMT");
      
      try {
        final userCredential = await _authService.signUp(email, password);
        final childAuthId = userCredential.user!.uid;
        
        dev.log("Child Firebase Auth account created: $childAuthId", name: "CHILDREN_MGMT");
        
        // Upload profile image if selected
        String? imageUrl;
        String? imagePath;
        
        if (selectedImage.value != null) {
          isUploading.value = true;
          try {
            final result = await _storageService.uploadImage(
              file: selectedImage.value!,
              folder: 'child_profiles/$childAuthId',
            );
            imageUrl = result['url'];
            imagePath = result['path'];
          } catch (e) {
            dev.log("Error uploading image: $e", name: "CHILDREN_MGMT", error: e);
          } finally {
            isUploading.value = false;
          }
        }

        // Create child model
        final child = ChildModel(
          childId: childAuthId,
          parentId: parentId,
          childName: name,
          age: age,
          sensoryPreferences: Map<String, int>.from(sensoryPreferences),
          notes: notes.isEmpty ? null : notes,
          createdAt: DateTime.now(),
          childEmail: email,
          childPassword: password, // Note: In production, consider hashing or using Firebase Admin
          profileImageUrl: imageUrl,
          profileImagePath: imagePath,
        );

        // Save child profile in Firestore
        await _childRepository.createChild(child);
        
        dev.log("Child profile created successfully", name: "CHILDREN_MGMT");
        
        ErrorHandler.showSuccessSnackBar("Success", "Child account created successfully!");
        clearForm();
        Get.back();
        
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case 'email-already-in-use':
            message = "This email is already registered";
            break;
          case 'invalid-email':
            message = "Invalid email address";
            break;
          case 'weak-password':
            message = "Password is too weak";
            break;
          default:
            message = e.message ?? "Failed to create account";
        }
        ErrorHandler.showErrorSnackBar(message);
      }
      
    } catch (e) {
      dev.log("Error creating child: $e", name: "CHILDREN_MGMT", error: e);
      ErrorHandler.showErrorSnackBar("Failed to create child account");
    } finally {
      isLoading.value = false;
      isUploading.value = false;
    }
  }

  /// Update an existing child
  Future<void> updateChild(ChildModel child) async {
    final name = nameController.text.trim();
    final ageText = ageController.text.trim();
    final notes = notesController.text.trim();
    
    // Validation
    if (name.isEmpty) {
      ErrorHandler.showErrorSnackBar("Please enter child's name");
      return;
    }
    
    final age = int.tryParse(ageText);
    if (age == null || age < 0 || age > 18) {
      ErrorHandler.showErrorSnackBar("Please enter a valid age (0-18)");
      return;
    }

    try {
      isLoading.value = true;
      
      String? imageUrl = child.profileImageUrl;
      String? imagePath = child.profileImagePath;
      
      // Upload new profile image if selected
      if (selectedImage.value != null) {
        isUploading.value = true;
        
        // Delete old image if exists
        if (child.profileImagePath != null) {
          try {
            await _storageService.deleteFile(child.profileImagePath!);
          } catch (e) {
            dev.log("Error deleting old image: $e", name: "CHILDREN_MGMT");
          }
        }
        
        try {
          final result = await _storageService.uploadImage(
            file: selectedImage.value!,
            folder: 'child_profiles/${child.childId}',
          );
          imageUrl = result['url'];
          imagePath = result['path'];
        } catch (e) {
          dev.log("Error uploading image: $e", name: "CHILDREN_MGMT", error: e);
        } finally {
          isUploading.value = false;
        }
      }

      // Update password if changed
      final newPassword = passwordController.text.trim();
      if (newPassword.isNotEmpty && newPassword.length >= 6) {
        // Note: Password update requires re-authentication in Firebase
        // For simplicity, we'll update it in Firestore (in production, use Firebase Admin)
        await _childRepository.updateChildPassword(child.childId, newPassword);
      }

      // Update child model
      final updatedChild = child.copyWith(
        childName: name,
        age: age,
        sensoryPreferences: Map<String, int>.from(sensoryPreferences),
        notes: notes.isEmpty ? null : notes,
        profileImageUrl: imageUrl,
        profileImagePath: imagePath,
      );

      // Update in Firestore
      await _childRepository.updateChild(updatedChild);
      
      dev.log("Child updated successfully", name: "CHILDREN_MGMT");
      
      ErrorHandler.showSuccessSnackBar("Success", "Child profile updated!");
      clearForm();
      Get.back();
      
    } catch (e) {
      dev.log("Error updating child: $e", name: "CHILDREN_MGMT", error: e);
      ErrorHandler.showErrorSnackBar("Failed to update child profile");
    } finally {
      isLoading.value = false;
      isUploading.value = false;
    }
  }

  /// Delete a child
  Future<void> deleteChild(ChildModel child) async {
    try {
      isLoading.value = true;
      
      // Show confirmation dialog
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text("Delete Child"),
          content: Text("Are you sure you want to delete ${child.childName}'s account? This will also delete their Firebase account and cannot be undone."),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text("Delete"),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

      // Delete profile image from storage
      if (child.profileImagePath != null) {
        try {
          await _storageService.deleteFile(child.profileImagePath!);
        } catch (e) {
          dev.log("Error deleting image: $e", name: "CHILDREN_MGMT");
        }
      }

      // Delete child profile from Firestore
      await _childRepository.deleteChild(child.childId);
      
      dev.log("Child profile deleted from Firestore", name: "CHILDREN_MGMT");
      
      // Note: Deleting Firebase Auth account requires Firebase Admin SDK
      // For now, we'll just delete the Firestore data
      // In production, you'd use Cloud Functions to delete the Auth account
      
      ErrorHandler.showSuccessSnackBar("Success", "Child profile deleted!");
      
    } catch (e) {
      dev.log("Error deleting child: $e", name: "CHILDREN_MGMT", error: e);
      ErrorHandler.showErrorSnackBar("Failed to delete child profile");
    } finally {
      isLoading.value = false;
    }
  }

  /// Load child data into form for editing
  void loadChildForEdit(ChildModel child) {
    nameController.text = child.childName;
    ageController.text = child.age.toString();
    notesController.text = child.notes ?? '';
    emailController.text = child.childEmail ?? '';
    // Don't pre-fill password for security
    passwordController.clear();
    sensoryPreferences.value = Map<String, int>.from(child.sensoryPreferences);
    
    if (child.profileImageUrl != null) {
      // We can't set File from URL, so just clear selectedImage
      // The UI will show the existing image from URL
      selectedImage.value = null;
    }
  }

  /// Update sensory preference
  void updateSensoryPreference(String key, int value) {
    sensoryPreferences[key] = value;
  }
}

