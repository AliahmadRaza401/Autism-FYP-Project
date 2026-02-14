import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/c_text.dart';
import '../../shared/widgets/custom_textfield.dart';
import '../../routes/app_pages.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  _buildCategoryChips(),
                  SizedBox(height: 16.h),
                  Expanded(child: _buildPostFeed()),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(Routes.POST_CREATION),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const CText(
          text: "Create Post",
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CText(
              text: "Community Posts",
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              hintText: "Search posts...",
              preffixIcon: Icon(Icons.search, color: AppColors.grey500),
              controller: controller.searchController,
              textcolor: AppColors.textPrimary,
              hasPreffix: true,
              backcolor: Colors.white.withValues(alpha: 0.15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Obx(() {
      if (controller.categories.isEmpty) {
        return const SizedBox.shrink();
      }

      return SizedBox(
        height: 40.h,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            // All Posts chip
            Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: ChoiceChip(
                label: const CText(text: "All Posts", fontSize: 12),
                selected: controller.selectedCategory.value == null,
                onSelected: (_) => controller.clearCategoryFilter(),
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.grey100,
                labelStyle: TextStyle(
                  color: controller.selectedCategory.value == null
                      ? Colors.white
                      : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Category chips
            ...controller.categories.map((category) {
              final isSelected = controller.selectedCategory.value?.id == category.id;
              return Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(category.icon, style: TextStyle(fontSize: 14.sp)),
                      SizedBox(width: 4.w),
                      CText(text: category.name, fontSize: 12),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (_) => controller.selectCategory(category),
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.grey100,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _buildPostFeed() {
    return Obx(() {
      final posts = controller.filteredPosts.isEmpty
          ? controller.allPosts
          : controller.filteredPosts;

      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (posts.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.post_add_outlined,
                size: 64.sp,
                color: AppColors.grey400,
              ),
              SizedBox(height: 16.h),
              CText(
                text: controller.selectedCategory.value != null
                    ? "No posts in this category yet"
                    : "No posts yet. Be the first to post!",
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.refreshPosts,
        child: ListView.builder(
          itemCount: posts.length,
          padding: EdgeInsets.only(bottom: 80.h),
          itemBuilder: (context, index) {
            final post = posts[index];
            return _buildPostCard(post);
          },
        ),
      );
    });
  }

  Widget _buildPostCard(post) {
    // Find category for this post
    final category = controller.categories.firstWhereOrNull(
      (cat) => cat.id == post.categoryId,
    );

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColors.grey200,
                backgroundImage: post.authorImage != null && post.authorImage!.isNotEmpty
                    ? NetworkImage(post.authorImage!)
                    : null,
                child: post.authorImage == null || post.authorImage!.isEmpty
                    ? Icon(Icons.person, color: AppColors.grey500)
                    : null,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CText(
                      text: post.authorName ?? "Parent",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    if (category != null)
                      Row(
                        children: [
                          Text(category.icon, style: TextStyle(fontSize: 10.sp)),
                          SizedBox(width: 4.w),
                          CText(
                            text: category.name,
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              CText(
                text: _getTimeAgo(post.createdAt),
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          
          // Title
          CText(
            text: post.title,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 8.h),
          
          // Description
          CText(
            text: post.description,
            fontSize: 14,
            color: AppColors.textPrimary,
            lineHeight: 1.5,
          ),
          
          // Image
          if (post.imageUrl != null && post.imageUrl!.isNotEmpty) ...[
            SizedBox(height: 12.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                post.imageUrl!,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150.h,
                    color: AppColors.grey100,
                    child: const Center(
                      child: Icon(Icons.broken_image, color: AppColors.grey400),
                    ),
                  );
                },
              ),
            ),
          ],
          
          SizedBox(height: 12.h),
          
          // Actions
          Row(
            children: [
              InkWell(
                onTap: () => controller.likePost(post.id),
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 20.sp,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 6.w),
                    CText(
                      text: post.likesCount.toString(),
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 24.w),
              Row(
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 20.sp,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: 6.w),
                  CText(
                    text: post.commentCount.toString(),
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) return "${difference.inDays}d ago";
    if (difference.inHours > 0) return "${difference.inHours}h ago";
    if (difference.inMinutes > 0) return "${difference.inMinutes}m ago";
    return "Just now";
  }
}
