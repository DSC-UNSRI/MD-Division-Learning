import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/auth_result.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<AuthResult> loginWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;

      if (user != null && !user.emailVerified) {
        if (kDebugMode) debugPrint('Email not verified for user: $email');
        return AuthResult(
          user: null,
          error: 'Email not verified. Please verify your email.',
        );
      }

      return AuthResult(user: user, error: null);
    } catch (e) {
      if (kDebugMode) debugPrint('Error during email login: $e');
      return AuthResult(user: null, error: 'Login failed. Please try again.');
    }
  }

  Future<AuthResult> registerWithEmail(
    String email, 
    String password, 
    String name,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'id': user.uid,
          'name': name,
          'bio': '',
          'email': email,
        });
        
        await user.sendEmailVerification();
        if (kDebugMode) debugPrint('Verification email sent to $email');
      }

      return AuthResult(user: user, error: null);
    } catch (e) {
      if (kDebugMode) debugPrint('Error during email registration: $e');
      return AuthResult(
        user: null,
        error: 'Registration failed. Please try again.',
      );
    }
  }

  Future<AuthResult> loginWithGoogle() async {
    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();

      final UserCredential userCredential =
          await _auth.signInWithProvider(googleProvider);
      
      final user = userCredential.user;
      if (user != null) {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        
        if (!userDoc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            'id': user.uid,
            'name': user.displayName ?? 'User',
            'bio': '',
            'email': user.email ?? '',
          });
        }
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
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    
    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('Error getting user data: $e');
      return null;
    }
  }
  Future<bool> updateUserProfile(String name, String bio) async {
    final user = _auth.currentUser;
    if (user == null) return false;
    
    try {
      await _firestore.collection('users').doc(user.uid).update({
        'name': name,
        'bio': bio,
      });
      return true;
    } catch (e) {
      if (kDebugMode) debugPrint('Error updating profile: $e');
      return false;
    }
  }
}