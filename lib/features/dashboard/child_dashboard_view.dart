import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../shared/widgets/custom_app_bar.dart';
import '../../core/constants/app_constants.dart';
import 'child_dashboard_controller.dart';
import '../../routes/app_pages.dart';
import '../../core/services/role_auth_service.dart';

class ChildDashboardView extends GetView<ChildDashboardController> {
  const ChildDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isParentFlow = Get.arguments != null;

    return Scaffold(
      appBar: CustomAppBar(
        text: "${controller.currentChild.value?.childName ?? 'Child'}'s Location", 
        leadingIcon: isParentFlow, 
        actions: [
          if (!isParentFlow) 
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () async {
                 await Get.find<RoleAuthService>().signOut();
                 Get.offAllNamed(Routes.SIGN_IN);
              },
            )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.currentPosition.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const CircularProgressIndicator(),
                SizedBox(height: 16.h),
                const Text("Loading Location..."),
                const Spacer(),
              ],
            ),
          );
        }

        if (controller.currentPosition.value == null) {
          return const Center(child: Text("Unable to get location."));
        }

        return Stack(
          children: [
            GoogleMap(
              onMapCreated: controller.onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  controller.currentPosition.value!.latitude,
                  controller.currentPosition.value!.longitude,
                ),
                zoom: 13,
              ),
              markers: controller.markers.toSet(),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
            ),
            
            Positioned(
              bottom: 24.h,
              left: 24.w,
              right: 24.w,
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: AppColors.primary, size: 24.w),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Current Location",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                              Text(
                                "Tracking Active Medical Facilities",
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (controller.distanceToCenter.value.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              "${controller.distanceToCenter.value} km",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: controller.openInGoogleMaps,
                        icon: const Icon(Icons.map),
                        label: const Text("Open in Google Maps"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

