import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/community_repository.dart';
import '../../data/models/group_model.dart';
import '../../core/utils/error_handler.dart';

class CommunityController extends GetxController {
  final CommunityRepository _communityRepository = Get.find<CommunityRepository>();

  final TextEditingController searchController = TextEditingController();
  final RxList<GroupModel> groups = <GroupModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    dev.log('CommunityController Initialized', name: 'COMMUNITY_DEBUG');
    groups.bindStream(_communityRepository.getGroups());
  }

  @override
  void onClose() {
    dev.log('CommunityController Closed', name: 'COMMUNITY_DEBUG');
    searchController.dispose();
    super.onClose();
  }

  Future<void> joinGroup(String groupId, String userId) async {
    try {
      await _communityRepository.joinGroup(groupId, userId);
      ErrorHandler.showSuccessSnackBar('Success', 'Joined group successfully!');
    } catch (e) {
      dev.log('Error joining group: $e', name: 'COMMUNITY_DEBUG');
      ErrorHandler.showErrorSnackBar(e);
    }
  }
}
