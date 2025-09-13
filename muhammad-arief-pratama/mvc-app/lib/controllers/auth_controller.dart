import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/auth_result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      String name, String email, String password) async {
    // Tambahkan parameter name
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        await user.sendEmailVerification();
        if (kDebugMode) debugPrint('Verification email sent to $email');

        // Simpan detail pengguna ke Firestore
        final newUser =
            UserModel(id: user.uid, name: name, email: email, bio: '');
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(newUser.toJson());
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
      // googleProvider.setCustomParameters({'prompt': 'select_account'}); // Opsional: selalu tampilkan pilihan akun
      final UserCredential userCredential =
          await _auth.signInWithProvider(googleProvider);
      final user = userCredential.user;

      if (user != null) {
        // Cek apakah user sudah ada di Firestore, jika tidak, buat dokumen baru
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          final newUser = UserModel(
            id: user.uid,
            name: user.displayName ?? 'Google User',
            email: user.email!,
            bio: '',
          );
          await _firestore
              .collection('users')
              .doc(user.uid)
              .set(newUser.toJson());
        }
      }
      return AuthResult(user: user, error: null);
    } catch (e) {
      // ... error handling ...
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

  // Mendapatkan detail user dari Firestore
  Future<UserModel?> getCurrentUserDetails() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;
    try {
      final docSnapshot =
          await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (docSnapshot.exists) {
        return UserModel.fromFirestore(
            // ignore: unnecessary_cast
            docSnapshot as DocumentSnapshot<Map<String, dynamic>>);
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching user details: $e');
    }
    return null;
  }

// Memperbarui profil user
  Future<bool> updateUserProfile(String userId, String name, String bio) async {
    try {
      await _firestore.collection('users').doc(userId).update({
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
