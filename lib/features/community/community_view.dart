import 'package:bluecircle/core/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../shared/widgets/custom_app_bar.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/c_text.dart';
import 'community_controller.dart';

class CommunityView extends GetView<CommunityController> {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(text: "Community", leadingIcon: false),
        body: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30.r),
                  ),
                ),
                child: Column(
                  children: [
                    TabBar(
                      labelColor: AppColors.primary,
                      unselectedLabelColor: AppColors.grey500,
                      indicatorColor: AppColors.primary,
                      tabs: const [
                        Tab(text: "Feed"),
                        Tab(text: "Groups"),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildPostFeed(),
                          _buildGroupsTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupsTab() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      children: [
        SizedBox(height: 20.h),
        _buildWelcomeCard(),
        SizedBox(height: 24.h),
        _buildBrowseGroups(),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildPostFeed() {
    return Column(
      children: [
        SizedBox(height: 16.h),
        _buildCategoryChips(),
        Expanded(
          child: Obx(() {
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
                      text: "No posts yet. Be the first to post!",
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
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 80.h),
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return _buildPostCard(post);
                },
              ),
            );
          }),
        ),
      ],
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
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          children: [
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

  Widget _buildPostCard(post) {
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
                    CText(
                      text: post.createdAt.toString().substring(0, 16),
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          CText(
            text: post.title,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 8.h),
          CText(
            text: post.description,
            fontSize: 14,
            color: AppColors.textPrimary,
            lineHeight: 1.5,
          ),
          if (post.imageUrl != null && post.imageUrl!.isNotEmpty) ...[
            SizedBox(height: 12.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                post.imageUrl!,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
          SizedBox(height: 12.h),
          Row(
            children: [
              InkWell(
                onTap: () => controller.likePost(post.id),
                child: Row(
                  children: [
                    Icon(Icons.favorite_border, size: 20.sp, color: AppColors.textSecondary),
                    SizedBox(width: 6.w),
                    CText(text: post.likesCount.toString(), fontSize: 14, color: AppColors.textSecondary),
                  ],
                ),
              ),
              SizedBox(width: 24.w),
              Row(
                children: [
                  Icon(Icons.chat_bubble_outline, size: 20.sp, color: AppColors.textSecondary),
                  SizedBox(width: 6.w),
                  CText(text: post.commentCount.toString(), fontSize: 14, color: AppColors.textSecondary),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildWelcomeCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CText(
            text: "Welcome to the Community",
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
          SizedBox(height: 6.h),
          CText(
            text: "Connect with other families who understand your journey",
            fontSize: 13,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildBrowseGroups() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CText(
          text: "Browse Groups",
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        SizedBox(height: 16.h),
        _groupTile(
          title: "Quiet Places",
          subtitle: "Share autism-friendly locations",
          members: "1,250 members",
          image: AppImages.quietPlaces,
        ),
        _groupTile(
          title: "Parent Support",
          subtitle: "Connect with other parents",
          members: "3,420 members",
          image: AppImages.heartLogo,
        ),
        _groupTile(
          title: "Sensory Activities",
          subtitle: "Activity ideas and tips",
          members: "890 members",
          image: AppImages.giftLogo,
        ),
        _groupTile(
          title: "School Support",
          subtitle: "Education and IEP help",
          members: "2,100 members",
          image: AppImages.bookSupport,
        ),
      ],
    );
  }

  Widget _groupTile({
    required String title,
    required String subtitle,
    required String members,
    required String image,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
              height: 46.h,
              width: 46.h,
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Image.asset(image)),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CText(
                  text: title,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                CText(
                  text: subtitle,
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.people_outline, size: 14.sp),
                    SizedBox(width: 4.w),
                    CText(text: members, fontSize: 11),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
