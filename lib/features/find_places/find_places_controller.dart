import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FindPlacesController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final List<String> categories = ["All", "Parks", "Museums", "Cafes", "Schools"];
  final RxString selectedCategory = "All".obs;

  void selectCategory(String category) {
    selectedCategory.value = category;
  }
}
