import 'package:firebase_auth/firebase_auth.dart';
import 'package:expense_tracker/core/error/result.dart';

abstract interface class AuthRepository {
  ResultFuture<UserCredential> signInWithGoogle();
  ResultVoid signOut();
  ResultVoid requestDrivePermission();
  Future<bool> isDrivePermissionGranted();
  Future<String?> getAccessToken();
  Stream<User?> get authStateChanges;
}
