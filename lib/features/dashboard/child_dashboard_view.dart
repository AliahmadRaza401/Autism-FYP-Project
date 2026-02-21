import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../shared/widgets/custom_app_bar.dart';
import '../../core/constants/app_constants.dart';
import '../find_places/find_places_view.dart';
import '../safe_zone/safe_zone_view.dart';
import 'child_dashboard_controller.dart';

class ChildDashboardView extends GetView<ChildDashboardController> {
  const ChildDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
        index: controller.tabIndex.value,
        children: const [
          FindPlacesView(),  
          SafeZoneView(),
          ChildProfileView(),
        ],
      )),
      bottomNavigationBar: Obx(() => Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: controller.tabIndex.value,
          onTap: controller.changeTabIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.grey500,
          showUnselectedLabels: true,
          backgroundColor: Colors.white,
          elevation: 10,
          selectedLabelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
          items: [
            _buildNavItem(Icons.map, "Map"),
            _buildNavItem(Icons.shield, "Safe Zones"),
            _buildNavItem(Icons.person, "Profile"),
          ],
        ),
      )),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Container(
        margin: EdgeInsets.only(bottom: 4.h),
        child: Icon(icon, size: 24.sp),
      ),
      label: label,
    );
  }
}

class ChildProfileView extends GetView<ChildDashboardController> {
  const ChildProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(text: "My Profile", leadingIcon: false),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final child = controller.currentChild.value;
        
        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50.r,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      backgroundImage: child?.profileImageUrl != null
                          ? NetworkImage(child!.profileImageUrl!)
                          : null,
                      child: child?.profileImageUrl == null
                          ? Icon(Icons.person, size: 50.r, color: AppColors.primary)
                          : null,
                    ),
                    SizedBox(height: 16.h),
                    
                    Text(
                      child?.childName ?? "Child",
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    
              
                    Text(
                      "Age: ${child?.age ?? 0}",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 20.h),
              
              _buildQuickAction(
                icon: Icons.favorite,
                title: "My Favorites",
                subtitle: "View saved places",
                onTap: () {
                },
              ),
              
              SizedBox(height: 12.h),
              
              _buildQuickAction(
                icon: Icons.shield,
                title: "My Safe Zones",
                subtitle: "View your safe places",
                onTap: () {
                  controller.changeTabIndex(1);
                },
              ),
              
              SizedBox(height: 12.h),
              
              _buildQuickAction(
                icon: Icons.settings,
                title: "Settings",
                subtitle: "App preferences",
                onTap: () {
                },
              ),
              
              SizedBox(height: 20.h),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    Get.find<dynamic>();
                    
                    Get.offAllNamed('/sign-in');
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: AppColors.primary, size: 24.w),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

