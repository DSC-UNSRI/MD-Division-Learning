import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/auth_result.dart';
import '../models/user_model.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Save user to Firestore
  Future<void> saveUserToFirestore(User user, {String name = ''}) async {
    try {
      final userModel = UserModel(
        id: user.uid,
        name: name.isNotEmpty ? name : user.displayName ?? user.email?.split('@')[0] ?? 'User',
        email: user.email ?? '',
      );

      await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
      if (kDebugMode) debugPrint('User data saved to Firestore for ${user.uid}');
    } catch (e) {
      if (kDebugMode) debugPrint('Error saving user data to Firestore: $e');
    }
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData(String userId) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(userId).get();
      if (docSnapshot.exists) {
        return UserModel.fromMap(docSnapshot.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('Error getting user data: $e');
      return null;
    }
  }

  // Update user profile
  Future<bool> updateUserProfile(String userId, {String? name, String? bio}) async {
    try {
      final Map<String, dynamic> updates = {};
      if (name != null) updates['name'] = name;
      if (bio != null) updates['bio'] = bio;
      
      await _firestore.collection('users').doc(userId).update(updates);
      return true;
    } catch (e) {
      if (kDebugMode) debugPrint('Error updating user profile: $e');
      return false;
    }
  }

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

  Future<AuthResult> registerWithEmail(String email, String password, String name) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        await user.sendEmailVerification();
        await saveUserToFirestore(user, name: name);
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
        // Check if user exists in Firestore, if not, save user data
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          await saveUserToFirestore(user);
        }
      }

      return AuthResult(user: userCredential.user, error: null);
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
}
