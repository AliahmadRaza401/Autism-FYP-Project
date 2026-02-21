import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/child_model.dart';
import '../../shared/widgets/custom_textfield.dart';
import '../../shared/widgets/custom_buttons.dart';
import 'children_management_controller.dart';

class AddEditChildView extends GetView<ChildrenManagementController> {
  const AddEditChildView({super.key});

  bool get isEditMode => Get.arguments != null && Get.arguments is ChildModel;
  ChildModel? get editChild => isEditMode ? Get.arguments as ChildModel : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? "Edit Child" : "Add Child"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image Section
            _buildImageSection(),
            SizedBox(height: 24.h),

            // Basic Info
            Text(
              "Basic Information",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16.h),

            // Name Field
            CustomTextField(
              controller: controller.nameController,
              hintText: "Enter child's full name",
              hasPreffix: true,
              preffixIcon: Icon(Icons.person, color: AppColors.grey500, size: 20.w),
            ),
            SizedBox(height: 16.h),

            // Age Field
            CustomTextField(
              controller: controller.ageController,
              hintText: "Enter child's age",
              keyboardType: TextInputType.number,
              hasPreffix: true,
              preffixIcon: Icon(Icons.cake, color: AppColors.grey500, size: 20.w),
            ),
            SizedBox(height: 16.h),

            // Email Field (only for new child)
            if (!isEditMode) ...[
              CustomTextField(
                controller: controller.emailController,
                hintText: "Enter email for child login",
                keyboardType: TextInputType.emailAddress,
                hasPreffix: true,
                preffixIcon: Icon(Icons.email, color: AppColors.grey500, size: 20.w),
              ),
              SizedBox(height: 16.h),

              // Password Field (only for new child)
              CustomTextField(
                controller: controller.passwordController,
                hintText: "Enter password for child login",
                isPassword: true,
                hasPreffix: true,
                preffixIcon: Icon(Icons.lock, color: AppColors.grey500, size: 20.w),
              ),
              SizedBox(height: 16.h),
            ],

            // Notes Field
            CustomTextField(
              controller: controller.notesController,
              hintText: "Any additional notes about the child",
              hasPreffix: true,
              preffixIcon: Icon(Icons.note, color: AppColors.grey500, size: 20.w),
              maxLines: 3,
            ),
            SizedBox(height: 24.h),

            // Sensory Preferences
            Text(
              "Sensory Preferences",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Rate the child's sensitivity levels (1-10)",
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 16.h),

            _buildSensorySlider("Noise Sensitivity", "noise"),
            _buildSensorySlider("Crowd Sensitivity", "crowd"),
            _buildSensorySlider("Light Sensitivity", "light"),
            _buildSensorySlider("Touch Sensitivity", "touch"),

            SizedBox(height: 32.h),

            // Submit Button
            Obx(() => PrimaryButton(
              text: isEditMode ? "Update Child" : "Create Child Account",
              onTap: () {
                if (isEditMode) {
                  controller.updateChild(editChild!);
                } else {
                  controller.createChild();
                }
              },
            )),

            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Center(
      child: Column(
        children: [
          Obx(() => Stack(
            children: [
              CircleAvatar(
                radius: 60.r,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                backgroundImage: controller.selectedImage.value != null
                    ? FileImage(controller.selectedImage.value!)
                    : (isEditMode && editChild?.profileImageUrl != null
                        ? NetworkImage(editChild!.profileImageUrl!)
                        : null),
                child: (controller.selectedImage.value == null && 
                       (isEditMode == false || editChild?.profileImageUrl == null))
                    ? Icon(Icons.person, size: 60.r, color: AppColors.primary)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _showImagePicker(),
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20.w,
                    ),
                  ),
                ),
              ),
            ],
          )),
          SizedBox(height: 8.h),
          Text(
            "Profile Photo",
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePicker() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16.w),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from Gallery"),
              onTap: () {
                Get.back();
                controller.pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take a Photo"),
              onTap: () {
                Get.back();
                controller.pickImageFromCamera();
              },
            ),
            if (controller.selectedImage.value != null || 
                (isEditMode && editChild?.profileImageUrl != null))
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text("Remove Photo", style: TextStyle(color: Colors.red)),
                onTap: () {
                  Get.back();
                  controller.clearImage();
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorySlider(String label, String key) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Obx(() => Text(
                "${controller.sensoryPreferences[key] ?? 5}",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              )),
            ],
          ),
          SizedBox(height: 8.h),
          Obx(() => Slider(
            value: (controller.sensoryPreferences[key] ?? 5).toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.grey300,
            onChanged: (value) {
              controller.updateSensoryPreference(key, value.round());
            },
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Low",
                style: TextStyle(fontSize: 12.sp, color: AppColors.grey500),
              ),
              Text(
                "High",
                style: TextStyle(fontSize: 12.sp, color: AppColors.grey500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

