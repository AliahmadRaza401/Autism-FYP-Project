import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/child_model.dart';
import 'children_management_controller.dart';

class ChildrenManagementView extends GetView<ChildrenManagementController> {
  const ChildrenManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Children"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              controller.clearForm();
              Get.toNamed('/add-child');
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.children.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: controller.children.length,
          itemBuilder: (context, index) {
            final child = controller.children[index];
            return _buildChildCard(child);
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          controller.clearForm();
          Get.toNamed('/add-child');
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text("Add Child"),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.child_care,
              size: 80.w,
              color: AppColors.grey400,
            ),
            SizedBox(height: 16.h),
            Text(
              "No Children Added Yet",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Add your children to manage their profiles and track their progress.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () {
                controller.clearForm();
                Get.toNamed('/add-child');
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Your First Child"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildCard(ChildModel child) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            // Navigate to child details or edit
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Profile Image
                CircleAvatar(
                  radius: 30.r,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  backgroundImage: child.profileImageUrl != null
                      ? NetworkImage(child.profileImageUrl!)
                      : null,
                  child: child.profileImageUrl == null
                      ? Icon(Icons.person, size: 30.r, color: AppColors.primary)
                      : null,
                ),
                SizedBox(width: 16.w),
                
                // Child Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        child.childName,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "Age: ${child.age}",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (child.notes != null && child.notes!.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(
                          child.notes!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.grey500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Actions
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: AppColors.textSecondary),
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        controller.loadChildForEdit(child);
                        Get.toNamed('/edit-child', arguments: child);
                        break;
                      case 'delete':
                        controller.deleteChild(child);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text("Edit"),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text("Delete", style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

