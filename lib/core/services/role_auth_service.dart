import 'dart:developer' as dev;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/child_repository.dart';
import '../../routes/app_pages.dart';

/// Service to handle role-based authentication and navigation OK Muhammd
class RoleAuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRepository _userRepository = Get.find<UserRepository>();
  // ignore: unused_field
  final ChildRepository _childRepository = Get.find<ChildRepository>();
  
  // Observable current user role
  final Rx<UserRole> currentRole = UserRole.parent.obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  User? get firebaseUser => _auth.currentUser;

  @override
  void onInit() {
    super.onInit();
    
    _auth.authStateChanges().listen((User? user) async {
      if (user != null) {
        await _determineUserRole(user.uid);
      } else {
        currentRole.value = UserRole.parent;
        currentUser.value = null;
      }
    });
  }
  Future<void> _determineUserRole(String uid) async {
    try {
      isLoading.value = true;
      dev.log("Determining role for user: $uid", name: "ROLE_AUTH");
      
      
      try {
        final user = await _userRepository.getUser(uid);
        currentUser.value = user;
        
        if (user!.role == 'child') {
          currentRole.value = UserRole.child;
          dev.log("User is a CHILD", name: "ROLE_AUTH");
        } else {
          currentRole.value = UserRole.parent;
          dev.log("User is a PARENT", name: "ROLE_AUTH");
        }
        return;
      } catch (e) {
        dev.log("User not found in users collection", name: "ROLE_AUTH");
      }
      
    
      currentRole.value = UserRole.parent;
      
    } catch (e) {
      dev.log("Error determining user role: $e", name: "ROLE_AUTH", error: e);
      currentRole.value = UserRole.parent;
    } finally {
      isLoading.value = false;
    }
  }

  
  void navigateBasedOnRole() {
    if (currentRole.value == UserRole.child) {
      dev.log("Navigating to Child Dashboard", name: "ROLE_AUTH");
      Get.offAllNamed(Routes.CHILD_DASHBOARD);
    } else {
      dev.log("Navigating to Parent Dashboard", name: "ROLE_AUTH");
      Get.offAllNamed(Routes.DASHBOARD);
    }
  }

  
  bool get isParent => currentRole.value == UserRole.parent;

  
  bool get isChild => currentRole.value == UserRole.child;

  
  Future<UserCredential> signInAsParent(String email, String password) async {
    try {
      isLoading.value = true;
      dev.log("Signing in as parent: $email", name: "ROLE_AUTH");
      
      final result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      
      
      await _determineUserRole(result.user!.uid);
      
      return result;
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  
  Future<UserCredential> signInAsChild(String email, String password) async {
    try {
      isLoading.value = true;
      dev.log("Signing in as child: $email", name: "ROLE_AUTH");
      
      final result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      
      
      currentRole.value = UserRole.child;
      
      return result;
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      isLoading.value = true;
      dev.log("Signing out", name: "ROLE_AUTH");
      
      await _auth.signOut();
      
      currentRole.value = UserRole.parent;
      currentUser.value = null;
      
      Get.offAllNamed(Routes.SIGN_IN);
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshUserData() async {
    if (firebaseUser != null) {
      await _determineUserRole(firebaseUser!.uid);
    }
  }
}

