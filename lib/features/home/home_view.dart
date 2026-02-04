import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/c_text.dart';
import '../../shared/widgets/custom_buttons.dart';

import '../../shared/widgets/place_card.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        toolbarHeight: 80.h,
        centerTitle: false, 

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CText(
              text: "Welcome Back,",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ],
        ),

        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: CircleAvatar(
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              radius: 20.r,
              child: const Icon(Icons.notifications_none, color: Colors.white),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section with background curve or just white background below blue appbar
            // Container(
            //   height: 20.h,
            //   decoration: const BoxDecoration(
            //     color: AppColors.primary,
            //     borderRadius: BorderRadius.only(
            //       bottomLeft: Radius.circular(30),
            //       bottomRight: Radius.circular(30),
            //     ),
            //   ),
            // ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  // Top Two Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildFeaturedCard(
                          icon: Icons.search,
                          title: "Find Places",
                          subtitle: "Search nearby",
                          onTap: controller.goToFindPlaces,
                          iconColor: AppColors.primary,
                          bgCircleColor: AppColors.primary.withOpacity(0.15),
                        ),
                      ),

                      SizedBox(width: 16.w),

                      Expanded(
                        child: _buildFeaturedCard(
                          icon: Icons.people_outline,
                          title: "Community",
                          subtitle: "Connect",
                          onTap: controller.goToCommunity,
                          iconColor: AppColors.kgreen,
                          bgCircleColor: AppColors.kgreen.withOpacity(0.15),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  // Large Button: Find Quiet Places
                  PrimaryIconButton(
                    text: "Find Quiet Places",
                    icon: Icons.location_on_sharp,
                    iconEnable: true,
                    radius: 20,
                    width: double.infinity,
                    onTap: controller.goToFindPlaces,
                  ),

                  SizedBox(height: 16.h),

                  // Two row buttons
                  _buildSmallActionButton(
                    icon: Icons.chat_bubble_outline,
                    label: "Open Community",
                    onTap: controller.goToCommunity,
                  ),
                  SizedBox(height: 12.w),
                  _buildSmallActionButton(
                    icon: Icons.security,
                    label: "Child Safety",
                    onTap: controller.goToChildSafety,
                  ),
                ],
              ),
            ),

            SizedBox(height: 32.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CText(
                    text: "Nearby Quiet Place",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  TextButton(
                    onPressed: controller.goToFindPlaces,
                    child: CText(
                      text: "See All",
                      fontSize: 14,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Nearby places cards
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: const Column(
                children: [
                  PlaceCard(
                    title: "Central Park",
                    address: "0.5 mi away",
                    rating: 4.8,
                    imagePath: "",
                  ),
                  PlaceCard(
                    title: "Garden",
                    address: "1.2 mi away",
                    rating: 4.5,
                    imagePath: "",
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Color? bgCircleColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: bgCircleColor ?? AppColors.primary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor ?? AppColors.primary,
                size: 24.sp,
              ),
            ),

            SizedBox(height: 12.h),

            CText(
              text: title,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),

            CText(
              text: subtitle,
              fontSize: 12,
              color: iconColor ?? AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, size: 22.sp, color: AppColors.textPrimary),
            SizedBox(width: 12.w),
            CText(
              text: label,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
