import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:google_sign_in/google_sign_in.dart';

import '../firebase_options.dart';

/// Handles Google Sign-In and Firebase Auth.
/// On Android, serverClientId must be set before authenticate().
class FirebaseAuthService {
  FirebaseAuthService({
    GoogleSignIn? googleSignIn,
    FirebaseAuth? firebaseAuth,
  })  : _googleSignIn = googleSignIn ?? GoogleSignIn.instance,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;
  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final serverClientId = DefaultFirebaseOptions.googleSignInWebClientId;
      if (serverClientId.isNotEmpty) {
        await _googleSignIn.initialize(serverClientId: serverClientId);
      }
    }
    _initialized = true;
  }

  /// Signs in with Google, then with Firebase. Returns user info for the backend
  /// (no idToken). Use this to create/update the user in MongoDB.
  /// Throws on cancel or failure.
  Future<Map<String, dynamic>> signInWithGoogleAndGetUserInfo() async {
    await _ensureInitialized();

    GoogleSignInAccount googleUser;
    try {
      googleUser = await _googleSignIn.authenticate();
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw FirebaseAuthServiceException('Sign-in was cancelled');
      }
      throw FirebaseAuthServiceException(e.description ?? e.toString());
    }

    final googleAuth = googleUser.authentication;
    final idToken = googleAuth.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw FirebaseAuthServiceException('Could not get ID token');
    }

    final credential = GoogleAuthProvider.credential(idToken: idToken);

    try {
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw FirebaseAuthServiceException('Could not get Firebase user');
      }

      // Collect maximum user info from Firebase User (from Google sign-in)
      return <String, dynamic>{
        'firebaseUid': firebaseUser.uid,
        'name': firebaseUser.displayName ?? googleUser.displayName ?? 'Member',
        'email': firebaseUser.email,
        'photoUrl': firebaseUser.photoURL ?? googleUser.photoUrl,
        'phoneNumber': firebaseUser.phoneNumber,
        'emailVerified': firebaseUser.emailVerified,
        // Extra from Google account if useful
        'googleId': googleUser.id,
      };
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        throw FirebaseAuthServiceException(
          'This email is already used with another sign-in method. '
          'Sign in with the original method or link accounts in your profile.',
        );
      }
      throw FirebaseAuthServiceException(e.message ?? e.toString());
    }
  }

  /// Signs out from Google and Firebase (e.g. when user logs out of the app).
  Future<void> signOut() async {
    await Future.wait([
      _googleSignIn.signOut(),
      _firebaseAuth.signOut(),
    ]);
  }

  /// Current Firebase user; null if not signed in.
  User? get currentFirebaseUser => _firebaseAuth.currentUser;
}

class FirebaseAuthServiceException implements Exception {
  FirebaseAuthServiceException(this.message);
  final String message;
  @override
  String toString() => message;
}
