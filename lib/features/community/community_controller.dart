import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/community_repository.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/models/post_model.dart';
import '../../core/utils/error_handler.dart';

class CommunityController extends GetxController {
  final CommunityRepository _communityRepository = Get.find<CommunityRepository>();
  final AuthRepository _authRepository = Get.find<AuthRepository>();
  final UserRepository _userRepository = Get.find<UserRepository>();

  final TextEditingController postController = TextEditingController();
  final RxList<PostModel> posts = <PostModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    dev.log('CommunityController Initialized', name: 'COMMUNITY_DEBUG');
    posts.bindStream(_communityRepository.getPosts());
  }

  @override
  void onClose() {
    dev.log('CommunityController Closed', name: 'COMMUNITY_DEBUG');
    postController.dispose();
    super.onClose();
  }

  Future<void> createPost() async {
    final content = postController.text.trim();
    
    dev.log('Attempting to create post', name: 'COMMUNITY_DEBUG');

    if (content.isEmpty) {
      Get.snackbar('Error', 'Post content cannot be empty');
      return;
    }

    if (content.length > 500) {
      Get.snackbar('Error', 'Post content is too long (max 500 characters)');
      return;
    }

    final userId = _authRepository.currentUser?.uid;
    if (userId == null) {
      dev.log('Create Post Failed: No user found', name: 'COMMUNITY_DEBUG');
      return;
    }

    try {
      isLoading.value = true;
      final user = await _userRepository.getUser(userId);
      
      final post = PostModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        authorId: userId,
        authorName: user.name,
        authorImage: user.profileImage,
        content: content,
        images: [],
        createdAt: DateTime.now(),
        likes: [],
      );

      await _communityRepository.createPost(post);
      dev.log('Post created successfully: ${post.id}', name: 'COMMUNITY_DEBUG');
      
      postController.clear();
      ErrorHandler.showSuccessSnackBar('Posted!', 'Your post has been shared with the community.');
      Get.back(); // Close post creation dialog/view
    } catch (e) {
      dev.log('Error creating post: $e', name: 'COMMUNITY_DEBUG', error: e);
      ErrorHandler.showErrorSnackBar(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> likePost(String postId) async {
    final userId = _authRepository.currentUser?.uid;
    if (userId == null) return;

    try {
      dev.log('Toggling like for post: $postId', name: 'COMMUNITY_DEBUG');
      await _communityRepository.likePost(postId, userId);
    } catch (e) {
      dev.log('Error toggling like: $e', name: 'COMMUNITY_DEBUG', error: e);
      ErrorHandler.showErrorSnackBar(e);
    }
  }
}
