import 'dart:developer' as dev;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/child_repository.dart';
import '../../routes/app_pages.dart';

/// Service to handle role-based authentication and navigation
class RoleAuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRepository _userRepository = Get.find<UserRepository>();
  final ChildRepository _childRepository = Get.find<ChildRepository>();
  
  // Observable current user role
  final Rx<UserRole> currentRole = UserRole.parent.obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  User? get firebaseUser => _auth.currentUser;

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) async {
      if (user != null) {
        await _determineUserRole(user.uid);
      } else {
        currentRole.value = UserRole.parent;
        currentUser.value = null;
      }
    });
  }

  /// Determine the user role based on user data in Firestore
  Future<void> _determineUserRole(String uid) async {
    try {
      isLoading.value = true;
      dev.log("Determining role for user: $uid", name: "ROLE_AUTH");
      
      // First, try to get user as parent
      try {
        final user = await _userRepository.getUser(uid);
        currentUser.value = user;
        
        if (user.role == 'child') {
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
      
      // If not found as parent, check if it's a child by looking up in children collection
      // We can check if the user's email matches any child's email
      // For now, default to parent
      currentRole.value = UserRole.parent;
      
    } catch (e) {
      dev.log("Error determining user role: $e", name: "ROLE_AUTH", error: e);
      currentRole.value = UserRole.parent;
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigate to appropriate dashboard based on role
  void navigateBasedOnRole() {
    if (currentRole.value == UserRole.child) {
      dev.log("Navigating to Child Dashboard", name: "ROLE_AUTH");
      Get.offAllNamed(Routes.CHILD_DASHBOARD);
    } else {
      dev.log("Navigating to Parent Dashboard", name: "ROLE_AUTH");
      Get.offAllNamed(Routes.DASHBOARD);
    }
  }

  /// Check if current user is a parent
  bool get isParent => currentRole.value == UserRole.parent;

  /// Check if current user is a child
  bool get isChild => currentRole.value == UserRole.child;

  /// Sign in as parent with email and password
  Future<UserCredential> signInAsParent(String email, String password) async {
    try {
      isLoading.value = true;
      dev.log("Signing in as parent: $email", name: "ROLE_AUTH");
      
      final result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      
      // Determine role after successful login
      await _determineUserRole(result.user!.uid);
      
      return result;
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Sign in as child using credentials stored by parent
  Future<UserCredential> signInAsChild(String email, String password) async {
    try {
      isLoading.value = true;
      dev.log("Signing in as child: $email", name: "ROLE_AUTH");
      
      final result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      
      // Set role as child for child login
      currentRole.value = UserRole.child;
      
      return result;
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Sign out and reset role
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

  /// Refresh user data
  Future<void> refreshUserData() async {
    if (firebaseUser != null) {
      await _determineUserRole(firebaseUser!.uid);
    }
  }
}

