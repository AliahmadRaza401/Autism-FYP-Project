import 'package:autismcare/core/constants/app_images.dart';
import 'package:autismcare/shared/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/c_text.dart';
import '../../shared/widgets/community_post_card.dart';
import 'community_controller.dart';
class CommunityView extends GetView<CommunityController> {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [

          /// HEADER
          _buildHeader(),

          /// BODY CONTAINER
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
              child: ListView(
                children: [

                  

                  _buildWelcomeCard(),

                  SizedBox(height: 6.h),

                  _buildBrowseGroups(),

                  // SizedBox(height: 24.h),

                  _buildRecentPosts(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= HEADER =================

  Widget _buildHeader() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                CText(
                  text: "Community",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ],
            ),

            SizedBox(height: 20.h),

            /// SEARCH BAR
              CustomTextField(
            hintText: "Serach groups ...",
            preffixIcon:  Icon(Icons.search, color: AppColors.grey500),
            controller: TextEditingController(),
            textcolor: AppColors.textPrimary,
            hasPreffix: true,
            backcolor: Colors.white.withOpacity(0.15), 
          ),
          ],
        ),
      ),
    );
  }

  /// ================= WELCOME CARD =================

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

  /// ================= GROUPS =================

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
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [

          /// ICON
          Container(
            height: 46.h,
            width: 46.h,
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Image.asset(image)
          ),

          SizedBox(width: 12.w),

          /// TEXT
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
                    SizedBox(width: 12.w),
                    Container(
                      height: 6,
                      width: 6,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    const CText(text: "Active", fontSize: 11),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ================= RECENT POSTS =================

  Widget _buildRecentPosts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        CText(
          text: "Recent Posts",
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),

        SizedBox(height: 16.h),

        CommunityPostCard(
          userName: "Sarah",
          timeAgo: "5 min ago",
          content: "Just discovered an amazing sensory-friendly library...",
          likes: 0,
          comments: 0,
        ),

        CommunityPostCard(
          userName: "Michael",
          timeAgo: "1 hour ago",
          content: "Does anyone have experience with speech therapy...",
          likes: 0,
          comments: 0,
        ),
      ],
    );
  }
}
