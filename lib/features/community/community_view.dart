import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../shared/widgets/custom_app_bar.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/c_text.dart';
import 'community_controller.dart';
import 'filtered_posts_view.dart';

class CommunityView extends GetView<CommunityController> {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(text: "Community", leadingIcon: false),
      body: _buildBrowseGroups(),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(.1),
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
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      children: [
        SizedBox(height: 20.h),
        _buildWelcomeCard(),
        SizedBox(height: 24.h),
        CText(
          text: "Browse Categories",
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        SizedBox(height: 16.h),
        Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.categories.isEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Center(child: CText(text: "No categories available", color: AppColors.textSecondary, fontSize: 16,)),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final category = controller.categories[index];
              return _categoryTile(
                title: category.name,
                subtitle: "Join the discussion",
                postsCount: "${category.postCount} posts",
                iconEmoji: category.icon,
                onTap: () {
                  controller.selectCategory(category);
                  Get.to(() => const FilteredPostsView());
                }
              );
            },
          );
        }),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _categoryTile({
    required String title,
    required String subtitle,
    required String postsCount,
    required String iconEmoji,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
                height: 48.h,
                width: 48.h,
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Center(
                  child: Text(iconEmoji, style: TextStyle(fontSize: 24.sp)),
                )),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CText(
                    text: title,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 4.h),
                  CText(
                    text: subtitle,
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(Icons.post_add, size: 14.sp, color: AppColors.primary),
                      SizedBox(width: 4.w),
                      CText(text: postsCount, fontSize: 11, color: AppColors.textSecondary),
                    ],
                  )
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.grey400),
          ],
        ),
      ),
    );
  }
}
