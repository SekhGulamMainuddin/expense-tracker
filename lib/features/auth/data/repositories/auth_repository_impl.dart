import 'package:expense_tracker/core/error/result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  }) : _firebaseAuth = firebaseAuth,
       _googleSignIn = googleSignIn;

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  GoogleSignInAccount? _googleAccount;

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  ResultFuture<UserCredential> signInWithGoogle() async {
    try {
      _googleAccount = await _googleSignIn.authenticate();
      final auth = _googleAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: auth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      return Success(userCredential);
    } on FirebaseAuthException catch (e) {
      return Error(AuthFailure(e.message ?? 'Authentication failed'));
    } catch (e) {
      print("SEKH BRO $e");
      return Error(UnexpectedFailure(e.toString()));
    }
  }

  static const _driveScope = 'https://www.googleapis.com/auth/drive.appdata';

  @override
  ResultVoid requestDrivePermission() async {
    try {
      final account = _googleAccount;
      if (account == null) {
        return Error(AuthFailure('Not signed in with Google'));
      }

      // Try to get existing authorization silently first
      final existing = await account.authorizationClient.authorizationForScopes(
        [_driveScope],
      );

      if (existing != null && existing.accessToken.isNotEmpty) {
        return const Success(null);
      }

      // Not granted — request it
      final result = await account.authorizationClient.authorizeScopes([
        _driveScope,
      ]);

      if (result.accessToken.isNotEmpty) {
        return const Success(null);
      } else {
        return Error(AuthFailure('Permission denied'));
      }
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<bool> isDrivePermissionGranted() async {
    final account = _googleAccount;
    if (account == null) return false;

    final authz = await account.authorizationClient.authorizationForScopes([
      _driveScope,
    ]);

    return authz != null && authz.accessToken.isNotEmpty;
  }

  @override
  Future<String?> getDriveAccessToken() async {
    final account = _googleAccount;
    if (account == null) return null;

    final authz = await account.authorizationClient.authorizationForScopes([
      _driveScope,
    ]);

    return authz?.accessToken;
  }

  @override
  ResultVoid signOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut(), _googleSignIn.disconnect()]);
      return const Success(null);
    } catch (e) {
      return Error(UnexpectedFailure(e.toString()));
    }
  }
}
