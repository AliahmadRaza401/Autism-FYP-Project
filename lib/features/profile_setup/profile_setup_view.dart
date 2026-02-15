import 'package:bluecircle/routes/app_pages.dart';
import 'package:bluecircle/shared/widgets/DOB_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/c_text.dart';
import '../../shared/widgets/custom_buttons.dart';
import '../../shared/widgets/custom_textfield.dart';
import 'profile_setup_controller.dart';

class ProfileSetupView extends GetView<ProfileSetupController> {
  const ProfileSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CText(
                    text: "Set Up Your Profile",
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  SizedBox(height: 4.h),
                  CText(
                    text: 'Help us personalize your experience',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: 24.h),

                  Center(
                    child: GestureDetector(
                      onTap: controller.pickImage,
                      child: Obx(
                        () => Stack(
                          children: [
                            CircleAvatar(
                              radius: 50.r,
                              backgroundColor: AppColors.grey200,
                              backgroundImage:
                                  controller.profileImage.value != null
                                  ? FileImage(controller.profileImage.value!)
                                  : null,
                              child: controller.profileImage.value == null
                                  ? Icon(
                                      Icons.person,
                                      size: 50.r,
                                      color: AppColors.grey400,
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(4.r),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 16.r,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

          
                  _buildSectionCard(
                    title: "Child Details",
                    children: [
                      _buildFieldLabel("Child's Name"),
                      CustomTextField(
                        hintText: "Enter child's name",
                        controller: controller.childNameController,
                        textcolor: AppColors.textPrimary,
                      ),
                      _buildFieldLabel("Date of Birth"),
                      DOBPickerField(
                        controller: controller,
                        labelText: "Date of Birth",
                      ),
                      _buildFieldLabel("Diagnosis (Optional)"),
                      CustomTextField(
                        hintText: "Enter diagnosis",
                        controller: controller.diagnosisController,
                        textcolor: AppColors.textPrimary,
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  SizedBox(
                    width: double.infinity,
                    child: _buildSectionCard(
                      title: "Primary Challenge",
                      children: [
                        Obx(
                          () => Wrap(
                            spacing: 8.w,
                            children: controller.challenges.map((challenge) {
                              final isSelected =
                                  controller.selectedChallenge.value ==
                                  challenge;
                              return ChoiceChip(
                                label: Text(challenge),
                                selected: isSelected,
                                onSelected: (selected) {
                                  if (selected)
                                    controller.setChallenge(challenge);
                                },
                                selectedColor: AppColors.primary,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

             
                  _buildSectionCard(
                    title: "Sensory Preference",
                    children: [
                      _buildSlider(
                        "Noise Sensitivity",
                        controller.noiseSensitivity,
                      ),
                      SizedBox(height: 16.h),
                      _buildSlider(
                        "Crowd Sensitivity",
                        controller.crowdSensitivity,
                      ),
                      SizedBox(height: 16.h),
                      _buildSlider(
                        "Light Sensitivity",
                        controller.lightSensitivity,
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

        
                  _buildSectionCard(
                    title: "Accessibility Settings",
                    children: [
                      _buildFieldLabel("Text Size"),
                      Column(
                        children: [
                          _buildRadioOption("Small", "small"),
                          _buildRadioOption("Medium", "medium"),
                          _buildRadioOption("Large", "large"),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 32.h),
                  PrimaryButton(
                    width: double.infinity,
                    text: "Complete Setup",
                    onTap: controller.completeSetup,
                  ),
                  SizedBox(height: 16.h),
                  Center(
                    child: TextButton(
                      onPressed: () => Get.toNamed(Routes.SAFE_ZONE),
                      child: CText(
                        text: "Skip for now",
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),

        
          Obx(
            () => controller.isLoading.value
                ? Container(
                    color: Colors.black26,
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CText(
              text: title,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            SizedBox(height: 12.h),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: CText(
        text: label,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildRadioOption(String label, String value) {
    return Obx(
      () => RadioListTile<String>(
        title: CText(text: label, fontSize: 14, color: AppColors.textPrimary),
        value: value,
        groupValue: controller.selectedTextSize.value,
        onChanged: (val) => controller.setTextSize(val!),
        activeColor: AppColors.primary,
        contentPadding: EdgeInsets.zero,
        dense: true,
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  Widget _buildSlider(String label, RxDouble value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CText(
              text: label,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            Obx(
              () => CText(
                text: value.value < 33
                    ? "Low"
                    : value.value < 66
                    ? "Medium"
                    : "High",
                fontSize: 14,
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Obx(
          () => SliderTheme(
            data: SliderTheme.of(Get.context!).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.grey200,
              thumbColor: Colors.white,
              trackHeight: 6.h,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 10.r,
                elevation: 2,
              ),
              overlayColor: AppColors.primary.withOpacity(0.1),
            ),
            child: Slider(
              value: value.value,
              min: 0,
              max: 100,
              onChanged: (val) => value.value = val,
            ),
          ),
        ),
      ],
    );
  }
}
