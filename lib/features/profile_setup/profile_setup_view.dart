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
      body: SafeArea(
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
              SizedBox(height: 32.h),

              // Child Details Card
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
                   CustomTextField(
                    hintText: "yyyy/mm/dd",
                    controller: controller.dobController,
                    keyboardType: TextInputType.datetime,
                    textcolor: AppColors.textPrimary,
                  ),
              
                  _buildFieldLabel("Child's Email"),
                  CustomTextField(
                    hintText: "Enter email address",
                    controller: TextEditingController(), // Placeholder if not in controller
                    keyboardType: TextInputType.emailAddress,
                    textcolor: AppColors.textPrimary,
                  ),
              
                  _buildFieldLabel("Password"),
                  CustomTextField(
                    hintText: "Enter password",
                    isPassword: true,
                    hasSuffix: true,
                    controller: TextEditingController(),
                    textcolor: AppColors.textPrimary,
                  ),
          
                  _buildFieldLabel("Confirm Password"),
                  CustomTextField(
                    hintText: "Confirm password",
                    isPassword: true,
                    hasSuffix: true,
                    controller: TextEditingController(),
                    textcolor: AppColors.textPrimary,
                  ),
                ],
              ),
              
      

              // Sensory Preference Card
              _buildSectionCard(
                title: "Sensory Preference",
                children: [
                   _buildSlider("Noise Sensitivity", controller.noiseSensitivity),
                   SizedBox(height: 16.h),
                   _buildSlider("Crowd Sensitivity", controller.crowdSensitivity),
                   SizedBox(height: 16.h),
                   _buildSlider("Light Sensitivity", controller.lightSensitivity),
                   PrimaryIconButton(text: 'Set Safe Zone',color: AppColors.kwhite,tcolor: AppColors.primary,iconEnable: true, onTap: controller.completeSetup, icon: Icons.arrow_forward,iconColor: AppColors.primary,)
                ],
              ),

              SizedBox(height: 24.h),

              _buildSectionCard(
                title: "Accessibility Settings",
                children: [
                  _buildFieldLabel("Text Size"),
                  Column(
  children: [
    _buildRadioOption("Small", "small", controller),
    _buildRadioOption("Medium", "medium", controller),
    _buildRadioOption("Large", "large", controller),
  ],
),

                ],
              ),

              SizedBox(height: 32.h),
              PrimaryButton(
                width: double.infinity,
                text: "Complete Setup", 
                onTap: controller.completeSetup
              ),
              SizedBox(height: 16.h),
              Center(
                child: TextButton(
                  onPressed: controller.completeSetup,
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
    );
  }

  Widget _buildSectionCard({required String title, required List<Widget> children}) {
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
            SizedBox(height: 20.h),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return CText(
      text: label,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    );
  }
  Widget _buildRadioOption(String label, String value, ProfileSetupController controller) {
  return Obx(() => Row(
        children: [
          Radio<String>(
            value: value,
            groupValue: controller.selectedTextSize.value,
            onChanged: (val) => controller.setTextSize(val!),
            activeColor: AppColors.primary,
          ),
          CText(
            text: label,
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
        ],
      ));
}


  // Widget _buildRadioOption(String label, String value, dynamic controller) {
  //   // Assuming controller has a textSize observable, adding it if not exists or using dummy
  //   return Row(
  //     children: [
  //       Radio<String>(
  //         value: value,
  //         groupValue: "medium", // Dummy for now
  //         onChanged: (val) {},
  //         activeColor: AppColors.primary,
  //       ),
  //       CText(text: label, fontSize: 14, color: AppColors.textPrimary),
  //     ],
  //   );
  // }

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
              overlayColor: AppColors.primary.withValues(alpha: 0.1),
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
