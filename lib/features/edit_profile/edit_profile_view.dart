import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';

import '../../shared/widgets/c_text.dart';
import '../../shared/widgets/custom_buttons.dart';
import '../../shared/widgets/custom_textfield.dart';
import 'edit_profile_controller.dart';
class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            SizedBox(width: 12.w),
            const CText(
              text: "Edit Profile",
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: ListView(
        children: [
          Center(
            child: CircleAvatar(
              radius: 50.r,
              backgroundColor: AppColors.primary.withValues(alpha: .1),
              child: Icon(Icons.person, size: 40.sp, color: AppColors.primary),
            ),
          ),
          SizedBox(height: 30.h),

          _label("Your Name"),
         CustomSecondTextField(
  controller: controller.nameController,
  hintText: "Mohammad Ahmad",
  hasPreffix: true,
  preffixIcon:
      Icon(Icons.person, color: AppColors.grey500),
)
,
          _label("Email Address"),
           CustomSecondTextField(
  controller: controller.emailController,
  hintText: "Email Address",
  hasPreffix: true,
  preffixIcon:
      Icon(Icons.email_outlined, color: AppColors.grey500),
)
,
          

          _label("Password"),
      CustomSecondTextField(
  controller: TextEditingController(),
  hintText: "********",
  isPassword: true,
  hasPreffix: true,
  hasSuffix: true,
  preffixIcon:
      Icon(Icons.lock_outline, color: AppColors.grey500),
)
,

          _label("Confirm Password"),
          CustomSecondTextField(
  controller: TextEditingController(),
  hintText: "********",
  isPassword: true,
  hasPreffix: true,
  hasSuffix: true,
  preffixIcon:
      Icon(Icons.lock_outline, color: AppColors.grey500),
)
,
          

          SizedBox(height: 30.h),

          PrimaryButton(
            text: "Save",
            onTap: controller.saveProfile,
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, top: 16.h),
      child: CText(text: text, fontWeight: FontWeight.w600, fontSize: 16.sp,),
    );
  }

  // ignore: unused_element
  Widget _input(TextEditingController controller, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          icon: Icon(icon),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
