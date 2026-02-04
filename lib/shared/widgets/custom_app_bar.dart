import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import 'c_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final bool leadingIcon;
  final Color? bgColor;
  final Color? tColor;

  const CustomAppBar({
    super.key,
    required this.text,
    this.leadingIcon = true,
    this.bgColor,
    this.tColor
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(120.h),
      child: AppBar(
        backgroundColor:bgColor?? Colors.transparent,
        // shadowColor: Colors.transparent,
        leadingWidth: 40.w,
        leading: leadingIcon
            ? GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: SizedBox(
                  width: 40.w,
                  height: 40.h,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Icon(
                        Icons.arrow_back,
                        color:tColor?? AppColors.kprimaryColor,
                        size: 24.w,
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
        title: CText(
          text: text,
          fontSize: 19,
          color:tColor?? Colors.black,
          fontWeight: FontWeight.w600,
          fontFamily: "Poppins",
        ),
        centerTitle: true,
        elevation: 0,
        actions: const [],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(70.h);
}

class CustomAppBar2 extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final bool leadingIcon;
  final bool centerTitle;

  const CustomAppBar2({
    super.key,
    required this.text,
    this.leadingIcon = true,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(120.h),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: AppBar(
          backgroundColor: Colors.transparent,
          leadingWidth: 14.w,
          leading: leadingIcon
              ? GestureDetector(
                  onTap: () => Get.back(),
                  child: SizedBox(
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.primarybackColor,
                        size: 20.w,
                      ),
                    ),
                  ),
                )
              : null,
          title: CText(
            text: text,
            fontSize: 20,
            color: AppColors.primarybackColor,
            fontWeight: FontWeight.w500,
            fontFamily: "Poppins",
          ),
          centerTitle: centerTitle, 
          elevation: 0,
          actions: const [],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(81.h);
}

class CustomMapAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final bool leadingIcon;

  const CustomMapAppBar({
    super.key,
    required this.text,
    this.leadingIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(120.h),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: AppBar(
          backgroundColor: Colors.transparent,
          leadingWidth: 40.w,
          leading: leadingIcon
              ? GestureDetector(
                  onTap: () => Get.back(),
                  child: SizedBox(
                    width: 34.w,
                    height: 34.h,
                    child: Icon(
                      Icons.arrow_back,
                      size: 22.w,
                      color: AppColors.kprimaryColor,
                    ),
                  ),
                )
              : null,
          title: CText(
            text: text,
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontFamily: "Poppins",
          ),
          centerTitle: true,
          elevation: 0,
          actions: [
            _buildActionButton(Icons.menu),
            SizedBox(width: 10.w),
            // _buildActionButton(Icons.notifications),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon) {
    return Container(
      width: 40.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: AppColors.kprimaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, size: 20.w),
        color: AppColors.kwhite,
        onPressed: () {
          // Get.toNamed(AppRoutes.notification);
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.h);
}
