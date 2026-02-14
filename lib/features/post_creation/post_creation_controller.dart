import 'dart:developer' as dev;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/repositories/community_repository.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/models/post_model.dart';
import '../../data/models/category_model.dart';
import '../../core/services/storage_service.dart';
import '../../core/utils/error_handler.dart';

class PostCreationController extends GetxController {
  final CommunityRepository _communityRepository = Get.find<CommunityRepository>();
  final CategoryRepository _categoryRepository = Get.find<CategoryRepository>();
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final UserRepository _userRepository = Get.find<UserRepository>();
  final StorageService _storageService = Get.find<StorageService>();

  //  ========Form controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Observable state ok Mohammad 
  final Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxBool isLoading = false.obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    dev.log('PostCreationController Initialized', name: 'POST_CREATION_DEBUG');
    categories.bindStream(_categoryRepository.getCategories());
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void selectCategory(CategoryModel category) {
    selectedCategory.value = category;
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (image != null) {
        selectedImage.value = File(image.path);
        dev.log('Image selected: ${image.path}', name: 'POST_CREATION_DEBUG');
      }
    } catch (e) {
      dev.log('Error picking image: $e', name: 'POST_CREATION_DEBUG');
      ErrorHandler.showErrorSnackBar('Failed to pick image');
    }
  }

  void removeImage() {
    selectedImage.value = null;
  }

  Future<void> createPost() async {
    // Validation
    if (selectedCategory.value == null) {
      ErrorHandler.showErrorSnackBar('Please select a category');
      return;
    }

    final title = titleController.text.trim();
    if (title.isEmpty) {
      ErrorHandler.showErrorSnackBar('Please enter a title');
      return;
    }

    final description = descriptionController.text.trim();
    if (description.isEmpty) {
      ErrorHandler.showErrorSnackBar('Please enter a description');
      return;
    }

    final userId = _authRepository.currentUser?.uid;
    if (userId == null) {
      ErrorHandler.showErrorSnackBar('User not authenticated');
      return;
    }

    try {
      isLoading.value = true;
      dev.log('Creating post...', name: 'POST_CREATION_DEBUG');

      // Get user info
      final user = await _userRepository.getUser(userId);

      // Upload image if selected
      String? imageUrl;
      if (selectedImage.value != null) {
        dev.log('Uploading image...', name: 'POST_CREATION_DEBUG');
        final fileName = 'post_${DateTime.now().millisecondsSinceEpoch}.jpg';
        imageUrl = await _storageService.uploadFile(
          path: 'posts/$userId/$fileName',
          file: selectedImage.value!,
        );
        dev.log('Image uploaded: $imageUrl', name: 'POST_CREATION_DEBUG');
      }

      // Create post
      final post = PostModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdBy: userId,
        title: title,
        description: description,
        categoryId: selectedCategory.value!.id,
        authorName: user.name,
        authorImage: user.profileImage,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
        likesCount: 0,
        commentCount: 0,
      );

      await _communityRepository.createPost(post);
      await _categoryRepository.incrementPostCount(selectedCategory.value!.id);

      dev.log('Post created successfully', name: 'POST_CREATION_DEBUG');
      ErrorHandler.showSuccessSnackBar('Success', 'Post created successfully!');

      // Clear form
      titleController.clear();
      descriptionController.clear();
      selectedCategory.value = null;
      selectedImage.value = null;

      // Close the creation screen
      Get.back();
    } catch (e) {
      dev.log('Error creating post: $e', name: 'POST_CREATION_DEBUG');
      ErrorHandler.showErrorSnackBar(e);
    } finally {
      isLoading.value = false;
    }
  }
}
