import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/community_repository.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/post_model.dart';
import '../../data/models/category_model.dart';
import '../../core/utils/error_handler.dart';

class HomeController extends GetxController {
  final CommunityRepository _communityRepository = Get.find<CommunityRepository>();
  final CategoryRepository _categoryRepository = Get.find<CategoryRepository>();
  final AuthRepository _authRepository = Get.find<AuthRepository>();


  final TextEditingController searchController = TextEditingController();

  
  final RxList<PostModel> allPosts = <PostModel>[].obs;
  final RxList<PostModel> filteredPosts = <PostModel>[].obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;

  
  final Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);

  
  final RxBool isLoading = false.obs;
  final RxBool isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
    dev.log('HomeController Initialized', name: 'HOME_DEBUG');
    
    
    allPosts.bindStream(_communityRepository.getPosts());
    categories.bindStream(_categoryRepository.getCategories());
    
    ever(allPosts, (_) => _filterPosts());
    ever(selectedCategory, (_) => _filterPosts());
    
    searchController.addListener(_onSearchChanged);
    
    _seedCategoriesIfNeeded();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> _seedCategoriesIfNeeded() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      if (categories.isEmpty) {
        dev.log('Seeding initial categories', name: 'HOME_DEBUG');
        await _categoryRepository.seedCategories();
      }
    } catch (e) {
      dev.log('Error seeding categories: $e', name: 'HOME_DEBUG');
    }
  }

  void _onSearchChanged() {
    _filterPosts();
  }

  void _filterPosts() {
    final query = searchController.text.toLowerCase();
    List<PostModel> posts = allPosts.toList();

    if (selectedCategory.value != null) {
      posts = posts.where((post) => post.categoryId == selectedCategory.value!.id).toList();
    }

    if (query.isNotEmpty) {
      posts = posts.where((post) {
        return post.title.toLowerCase().contains(query) ||
            post.description.toLowerCase().contains(query);
      }).toList();
    }

    filteredPosts.value = posts;
  }

  void selectCategory(CategoryModel? category) {
    selectedCategory.value = category;
  }

  void clearCategoryFilter() {
    selectedCategory.value = null;
  }

  Future<void> likePost(String postId) async {
    final userId = _authRepository.currentUser?.uid;
    if (userId == null) return;

    try {
      await _communityRepository.likePost(postId, userId);
    } catch (e) {
      dev.log('Error liking post: $e', name: 'HOME_DEBUG');
      ErrorHandler.showErrorSnackBar(e);
    }
  }

  Future<void> refreshPosts() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
