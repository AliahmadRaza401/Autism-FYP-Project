import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/c_text.dart';


import '../../shared/widgets/custom_textfield.dart';
import '../../shared/widgets/place_card.dart';
import 'find_places_controller.dart';

class FindPlacesView extends GetView<FindPlacesController> {
  const FindPlacesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
  backgroundColor: AppColors.primary,
  elevation: 0,

  title: CText(
    text: "Find Places",
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),

  actions: [
    IconButton(
      icon: const Icon(Icons.map_outlined, color: Colors.white),
      onPressed: () {},
    )
  ],

  // 👇 This adds widgets BELOW title inside AppBar
  bottom: PreferredSize(
    preferredSize: Size.fromHeight(100.h),
    child: Padding(
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
      child: Column(
        children: [
          CustomTextField(
            hintText: "Search parks, clinics, malls...",
            preffixIcon:  Icon(Icons.search, color: AppColors.grey500),
            controller: controller.searchController,
           textcolor: AppColors.textPrimary,
            hasPreffix: true,
            backcolor: Colors.white.withOpacity(0.15), 
          ),

         
        ],
      ),
    ),
  ),
),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 24.w),
          //   child: Column(
          //     children: [
          //       CustomTextField(
          //         hintText: "Search parks, clinics, malls...",
          //         preffixIcon: const Icon(Icons.search, color: AppColors.grey500),
          //         controller: controller.searchController,
          //         textcolor: AppColors.textPrimary,
          //       ),
          //       SizedBox(height: 12.h),
          //       _buildFilterButton(),
          //     ],
          //   ),
          // ),
          
          // SizedBox(height: 24.h),
           SizedBox(height: 12.h),

          Padding(
             padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: _buildFilterButton(),
          ),
          
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 10.w),
            child: Row(
              children: [

                CText(
                  text: "5 places nearby",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color:AppColors.kpurple,
                ),
              ],
            ),
          ),
          
          SizedBox(height: 16.h),

          // List of Places
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              children: const [
                PlaceCard(
                  title: "Park",
                  address: "0.5 mi away",
                  rating: 4.5,
                  imagePath: "",
                ),
                PlaceCard(
                  title: "Library Community Roo",
                  address: "1.2 mi away",
                  rating: 4.8,
                  imagePath: "",
                ),
                PlaceCard(
                  title: "Sensory-Friendly Cinem",
                  address: "2.1 mi away",
                  rating: 4.3,
                  imagePath: "",
                ),
                PlaceCard(
                  title: "Autism-Friendly Museu",
                  address: "3.4 mi away",
                  rating: 4.6,
                  imagePath: "",
                ),
                PlaceCard(
                  title: "Sensory Garden Caf",
                  address: "4.2 mi away",
                  rating: 4.7,
                  imagePath: "",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.filter_list, color: AppColors.grey500, size: 20),
          SizedBox(width: 8.w),
          CText(
            text: "Filter by Sensory Levels",
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
