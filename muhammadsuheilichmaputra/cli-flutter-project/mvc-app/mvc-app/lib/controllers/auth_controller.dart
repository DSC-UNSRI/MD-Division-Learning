import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:flutter/foundation.dart';
import '../models/auth_result.dart';
import '../models/user_model.dart';

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

  Future<AuthResult> registerWithEmail(String name, String email, String password) async {
    UserCredential? userCredential;

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? authUser = userCredential.user;
      if (authUser != null) {
        try {
        await authUser.sendEmailVerification();
        if (kDebugMode) debugPrint('Verification email sent to $email');

        await _firestore.collection('users').doc(authUser.uid).set({
          'id': authUser.uid,
          'name': name,
          'email': authUser.email, 
          'bio': '',
          'createdAt': FieldValue.serverTimestamp(),
        });
        if (kDebugMode) debugPrint('User details saved to Firestore for ${authUser.uid}');

        return AuthResult(user: authUser, error: null);

      } catch (postAuthError) {
        
        if (kDebugMode) debugPrint('Error after Auth user creation (verification/firestore): $postAuthError. Auth User ID: ${authUser.uid}');
        return AuthResult(
          user: authUser, 
          error: 'Account created, but setup was incomplete: ${postAuthError.toString()}. Please try to login or verify your email if received.',
        );
      }
      } else {
      return AuthResult(user: null, error: 'User object was null after successful auth creation.');
    }
    

  } on FirebaseAuthException catch (authException) {
    if (kDebugMode) debugPrint('FirebaseAuthException during registration: ${authException.code} - ${authException.message}');
    String errorMessage = 'Registration failed. Please try again.';
    if (authException.code == 'email-already-in-use') {
      errorMessage = 'This email is already registered. Please try logging in or use a different email.';
    } else if (authException.code == 'weak-password') {
      errorMessage = 'The password is too weak. Please choose a stronger password.';
    } 
    return AuthResult(user: null, error: errorMessage);

  } catch (generalException) {

    if (kDebugMode) debugPrint('Generic error during registration: $generalException');
    return AuthResult(user: null, error: 'An unexpected error occurred during registration.');
  }
}

  Future<AuthResult> loginWithGoogle() async {
    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();

      final UserCredential userCredential =
          await _auth.signInWithProvider(googleProvider);

      final user = userCredential.user; 

      if (user != null) { 
        final userDocRef = _firestore.collection('users').doc(user.uid); 
        final userDoc = await userDocRef.get();

        if (!userDoc.exists) {
          await userDocRef.set({
            'id': user.uid, 
            'name': user.displayName ?? '', 
            'email': user.email, 
            'bio': '', 
            'createdAt': FieldValue.serverTimestamp(),
    
          });
          if (kDebugMode) debugPrint('New Google user details saved to Firestore for ${user.uid}');
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

  // Di dalam class AuthController (AuthController.dart)

  Future<UserModel?> getCurrentUserData() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) {
      if (kDebugMode) {
        print("[AUTH_DEBUG] getCurrentUserData: Tidak ada pengguna yang login (firebaseUser is null).");
      }
      return null;
    }

    if (kDebugMode) {
      print("[AUTH_DEBUG] getCurrentUserData: Mencoba mengambil data untuk UID: ${firebaseUser.uid}");
    }

    try {
      final docSnapshot = await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (docSnapshot.exists) {
        if (kDebugMode) {
          print("[AUTH_DEBUG] getCurrentUserData: Dokumen pengguna DITEMUKAN untuk UID: ${firebaseUser.uid}. Data: ${docSnapshot.data()}");
        }
        try {
          return UserModel.fromFirestore(docSnapshot as DocumentSnapshot<Map<String, dynamic>>);
        } catch (e_parse) {
          if (kDebugMode) {
            print("[AUTH_DEBUG] getCurrentUserData: ERROR SAAT PARSING UserModel.fromFirestore: $e_parse. Data mentah: ${docSnapshot.data()}");
          }
          return null;
        }
      } else {
        if (kDebugMode) {
          print("[AUTH_DEBUG] getCurrentUserData: Dokumen pengguna TIDAK DITEMUKAN di Firestore untuk UID: ${firebaseUser.uid}.");
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("[AUTH_DEBUG] getCurrentUserData: ERROR UTAMA saat mengambil dokumen dari Firestore: $e");
      }
      return null;
    }

  }

  Future<void> updateUserProfile({
    required String name,
    required String bio,
  }) async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) {
      throw Exception("User not logged in");
    }
    try {
      await _firestore.collection('users').doc(firebaseUser.uid).update({
        'name': name,
        'bio': bio,
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error updating user profile: $e");
      }
      throw Exception("Failed to update profile");
    }
  }

}


