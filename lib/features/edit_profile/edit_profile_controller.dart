import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  final TextEditingController nameController = TextEditingController(text: "Ahmed's Mom");
  final TextEditingController emailController = TextEditingController(text: "ahmed.mom@email.com");
  final TextEditingController phoneController = TextEditingController(text: "+1 234 567 890");
  final TextEditingController dobController = TextEditingController(text: "12/12/1990");
  
  void saveProfile() {
    Get.back();
    Get.snackbar("Success", "Profile Updated Successfully");
  }
}
