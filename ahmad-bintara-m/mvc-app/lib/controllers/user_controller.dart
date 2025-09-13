// lib/controllers/user_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Fungsi untuk menyimpan data pengguna ke Firestore
  Future<void> saveUserData(UserModel user) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    
    if (userId == null) {
      throw Exception("Pengguna tidak terautentikasi.");
    }

    // Menyimpan data pengguna di Firestore di bawah dokumen dengan ID sesuai dengan userId
    await _firestore.collection('users').doc(userId).set(user.toMap());
  }

  // Fungsi untuk mendapatkan data pengguna berdasarkan userId
  Future<UserModel> getUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    
    if (userId == null) {
      throw Exception("Pengguna tidak terautentikasi.");
    }

    // Mengambil data pengguna dari Firestore
    final userSnapshot = await _firestore.collection('users').doc(userId).get();

    if (!userSnapshot.exists) {
      throw Exception("Data pengguna tidak ditemukan.");
    }

    return UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);
  }
}
