import 'package:bluecircle/shared/widgets/custom_app_bar.dart';
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
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(text: "Edit Profile"),
      body: Stack(
        children: [
          _buildBody(),
          Obx(() => controller.isLoading.value
              ? Container(
                  color: Colors.black26,
                  child: const Center(child: CircularProgressIndicator()),
                )
              : const SizedBox.shrink()),
        ],
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
            child: GestureDetector(
              onTap: controller.pickImage,
              child: Obx(() {
                final img = controller.profileImage.value;
                final user = controller.user.value;
                
                return Stack(
                  children: [
                    CircleAvatar(
                      radius: 50.r,
                      backgroundColor: AppColors.grey200,
                      backgroundImage: img != null 
                        ? FileImage(img) as ImageProvider 
                        : (user?.profileImage != null ? NetworkImage(user!.profileImage!) : null),
                      child: (img == null && user?.profileImage == null)
                          ? Icon(Icons.person, size: 50.r, color: AppColors.grey400)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(Icons.camera_alt, color: Colors.white, size: 16.w),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          SizedBox(height: 30.h),
          _buildLabel("Your Name"),
          CustomSecondTextField(
            controller: controller.nameController,
            hintText: "Enter your name",
            hasPreffix: true,
            preffixIcon: Icon(Icons.person, color: AppColors.grey500),
          ),
          _buildLabel("Email Address"),
          CustomSecondTextField(
            controller: controller.emailController,
            hintText: "Enter email",
            hasPreffix: true,
            
            preffixIcon: Icon(Icons.email_outlined, color: AppColors.grey500),
          ),
          _buildLabel("Phone Number"),
          CustomSecondTextField(
            controller: controller.phoneController,
            hintText: "Enter phone number",
            hasPreffix: true,
            keyboardType: TextInputType.phone,
            preffixIcon: Icon(Icons.phone_outlined, color: AppColors.grey500),
          ),
          _buildLabel("Emergency Contact"),
          CustomSecondTextField(
            controller: controller.emergencyController,
            hintText: "Emergency contact name/phone",
            hasPreffix: true,
            preffixIcon: Icon(Icons.contact_phone_outlined, color: AppColors.grey500),
          ),
          _buildLabel("Password"),
          CustomSecondTextField(
            controller: controller.passwordController,
            hintText: "Enter new password",
            isPassword: true,
            hasPreffix: true,
            hasSuffix: true,
            preffixIcon: Icon(Icons.lock_outline, color: AppColors.grey500),
          ),
          _buildLabel("Confirm Password"),
          CustomSecondTextField(
            controller: controller.confirmPasswordController,
            hintText: "Confirm password",
            isPassword: true,
            hasPreffix: true,
            hasSuffix: true,
            preffixIcon: Icon(Icons.lock_outline, color: AppColors.grey500),
          ),
          SizedBox(height: 30.h),
          PrimaryButton(
            text: "Save",
            onTap: controller.saveProfile,
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, top: 16.h),
      child: CText(
        text: text,
        fontWeight: FontWeight.w600,
        fontSize: 16.sp,
      ),
    );
  }
}
