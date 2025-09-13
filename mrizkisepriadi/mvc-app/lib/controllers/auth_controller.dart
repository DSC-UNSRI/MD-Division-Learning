import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:testing/controllers/notification_controller.dart';

import '../models/auth_result.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<AuthResult> loginWithEmail(String email, String password) async {
    try {
      if (kDebugMode) {
        debugPrint('🔐 Attempting email login for: $email');
      }

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;

      if (user != null && !user.emailVerified) {
        if (kDebugMode) debugPrint('⚠️ Email not verified for user: $email');
        return AuthResult(
          user: null,
          error: 'Email not verified. Please verify your email.',
        );
      }

      // Initialize notifications after successful login
      if (user != null) {
        if (kDebugMode) {
          debugPrint('✅ Email login successful for: ${user.email}');
          debugPrint('👤 User ID: ${user.uid}');
          debugPrint('🔔 Initializing notifications...');
        }

        try {
          await NotificationController.initialize();
          NotificationController.listenToTokenRefresh();
          if (kDebugMode) {
            debugPrint('✅ Notifications initialized after login');
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint('❌ Failed to initialize notifications after login: $e');
          }
          // Don't fail login if notifications fail
        }
      }

      return AuthResult(user: user, error: null);
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error during email login: $e');
      return AuthResult(user: null, error: 'Login failed. Please try again.');
    }
  }

  Future<AuthResult> registerWithEmail(String email, String password) async {
    try {
      if (kDebugMode) {
        debugPrint('📝 Attempting registration for: $email');
      }

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        await user.sendEmailVerification();
        if (kDebugMode) debugPrint('📧 Verification email sent to $email');
      }

      return AuthResult(user: user, error: null);
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error during email registration: $e');
      return AuthResult(
        user: null,
        error: 'Registration failed. Please try again.',
      );
    }
  }

  Future<AuthResult> loginWithGoogle() async {
    try {
      if (kDebugMode) {
        debugPrint('🔐 Attempting Google login...');
      }

      final GoogleAuthProvider googleProvider = GoogleAuthProvider();

      final UserCredential userCredential =
          await _auth.signInWithProvider(googleProvider);

      // Initialize notifications after successful Google login
      if (userCredential.user != null) {
        if (kDebugMode) {
          debugPrint(
              '✅ Google login successful for: ${userCredential.user!.email}');
          debugPrint('👤 User ID: ${userCredential.user!.uid}');
          debugPrint('🔔 Initializing notifications...');
        }

        try {
          await NotificationController.initialize();
          NotificationController.listenToTokenRefresh();
          if (kDebugMode) {
            debugPrint('✅ Notifications initialized after Google login');
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint(
                '❌ Failed to initialize notifications after Google login: $e');
          }
          // Don't fail login if notifications fail
        }
      }

      return AuthResult(user: userCredential.user, error: null);
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error during Google login: $e');
      return AuthResult(
          user: null, error: 'Google login failed. Please try again.');
    }
  }

  Future<bool> logout() async {
    try {
      if (kDebugMode) {
        debugPrint('🔐 Logging out user...');
      }
      await _auth.signOut();
      if (kDebugMode) {
        debugPrint('✅ User logged out successfully');
      }
      return true;
    } catch (e) {
      if (kDebugMode) debugPrint('❌ Error during logout: $e');
      return false;
    }
  }
}
