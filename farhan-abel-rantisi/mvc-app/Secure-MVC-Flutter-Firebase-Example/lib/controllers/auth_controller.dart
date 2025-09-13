import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/auth_result.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  User? getCurrentUser() => _auth.currentUser;
  String? getCurrentUserId() => _auth.currentUser?.uid;

  Future<AuthResult> loginWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;

      if (user != null && !user.emailVerified) {
        return AuthResult(
          user: null,
          error: 'Email not verified. Please verify your email.',
        );
      }

      if (user != null) {
        await _saveAndListenDeviceToken(user.uid);
      }

      return AuthResult(user: user, error: null);
    } catch (e) {
      if (kDebugMode) debugPrint('Error during email login: $e');
      return AuthResult(user: null, error: 'Login failed. Please try again.');
    }
  }

  Future<AuthResult> registerWithEmail(
      String name, String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user != null) {
        await _usersCollection.doc(user.uid).set({
          'id': user.uid,
          'name': name,
          'bio': '',
          'email': email,
        });

        await user.sendEmailVerification();
        await _saveAndListenDeviceToken(user.uid);
      }

      return AuthResult(user: user, error: null);
    } catch (e) {
      if (kDebugMode) debugPrint('Error during email registration: $e');
      return AuthResult(
          user: null, error: 'Registration failed. Please try again.');
    }
  }

  Future<AuthResult> loginWithGoogle() async {
    try {
      final googleProvider = GoogleAuthProvider();
      final userCredential =
          await _auth.signInWithProvider(googleProvider);

      final user = userCredential.user;
      if (user != null) {
        await _saveAndListenDeviceToken(user.uid);
      }

      return AuthResult(user: user, error: null);
    } catch (e) {
      if (kDebugMode) debugPrint('Error during Google login: $e');
      return AuthResult(
          user: null, error: 'Google login failed. Please try again.');
    }
  }

  Future<bool> logout() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      if (kDebugMode) debugPrint('Error during logout: $e');
      return false;
    }
  }

  Future<void> _saveAndListenDeviceToken(String userId) async {
    await saveDeviceToken(userId);

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      await _saveTokenToFirestore(userId, newToken);
    });
  }

  Future<void> saveDeviceToken(String userId) async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await _saveTokenToFirestore(userId, token);
    }
  }

  Future<void> _saveTokenToFirestore(String userId, String token) async {
    final tokenRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('device_tokens')
        .doc(token);

    await tokenRef.set({
      'token': token,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
