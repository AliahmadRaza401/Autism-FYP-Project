import 'dart:developer' as dev;
import 'package:get/get.dart';
import '../../../data/models/child_model.dart';
import '../../../data/repositories/child_repository.dart';
import '../../../core/services/role_auth_service.dart';

class ChildDashboardController extends GetxController {
  final ChildRepository _childRepository = Get.find<ChildRepository>();
  final RoleAuthService _roleAuthService = Get.find<RoleAuthService>();
  
  final Rx<ChildModel?> currentChild = Rx<ChildModel?>(null);
  final RxList<ChildModel> children = <ChildModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt tabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadChildProfile();
  }

  /// Load the current child's profile based on the logged in user's email
  Future<void> _loadChildProfile() async {
    try {
      isLoading.value = true;
      final currentUser = _roleAuthService.firebaseUser;
      
      if (currentUser != null) {
        dev.log("Loading child profile for: ${currentUser.email}", name: "CHILD_DASHBOARD");
        
        // Get the child's profile from Firestore using the user's UID
        // We need to find the child by matching the Firebase UID
        // The child's document ID should match their Firebase UID
        try {
          final childDoc = await _childRepository.getChild(currentUser.uid);
          currentChild.value = childDoc;
          dev.log("Child profile loaded: ${childDoc.childName}", name: "CHILD_DASHBOARD");
        } catch (e) {
          dev.log("Child profile not found: $e", name: "CHILD_DASHBOARD");
        }
      }
    } catch (e) {
      dev.log("Error loading child profile: $e", name: "CHILD_DASHBOARD", error: e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Change the tab index
  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  /// Refresh the child profile
  Future<void> refreshProfile() async {
    await _loadChildProfile();
  }

  /// Get the current child's name
  String get childName => currentChild.value?.childName ?? 'Child';

  /// Get the current child's age
  int get childAge => currentChild.value?.age ?? 0;

  /// Get the current child's profile image URL
  String? get profileImageUrl => currentChild.value?.profileImageUrl;
}

