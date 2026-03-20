import 'package:firebase_auth/firebase_auth.dart';
import '../../core/services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  Stream<User?> get authStateChanges => _authService.authStateChanges;

  User? get currentUser => _authService.currentUser;

  Future<UserCredential> signUp(String email, String password) async {
    return await _authService.signUp(email, password);
  }

  Future<UserCredential> signIn(String email, String password) async {
    return await _authService.signIn(email, password);
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<UserCredential?> signInWithGoogle() async {
    return await _authService.signInWithGoogle();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _authService.sendPasswordResetEmail(email);
  }

  Future<void> sendEmailVerification() async {
    await _authService.sendEmailVerification();
  }

  Future<void> deleteAccount() async {
    await _authService.deleteAccount();
  }

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) codeSent,
    required void Function(FirebaseAuthException error) verificationFailed,
    void Function(PhoneAuthCredential credential)? verificationCompleted,
    void Function(String verificationId)? codeAutoRetrievalTimeout,
    int? forceResendingToken,
  }) async {
    await _authService.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeSent: codeSent,
      verificationFailed: verificationFailed,
      verificationCompleted: verificationCompleted,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      forceResendingToken: forceResendingToken,
    );
  }

  PhoneAuthCredential buildPhoneAuthCredential({
    required String verificationId,
    required String smsCode,
  }) {
    return _authService.buildPhoneAuthCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }

  Future<UserCredential> signInWithPhoneCredential(AuthCredential credential) async {
    return _authService.signInWithPhoneCredential(credential);
  }

  Future<UserCredential> linkPhoneCredential(AuthCredential credential) async {
    return _authService.linkPhoneCredential(credential);
  }
}
