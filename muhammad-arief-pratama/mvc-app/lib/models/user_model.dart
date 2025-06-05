import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id; // Firebase UID
  final String name;
  final String email;
  final String? bio; // Bio bisa null atau string kosong

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.bio,
  });

  // Untuk mengubah UserModel menjadi Map agar bisa disimpan ke Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'bio': bio ?? '', // Simpan string kosong jika bio null
    };
  }

  // Untuk membuat UserModel dari Snapshot Firestore
  factory UserModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return UserModel(
      id: snapshot.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      bio: data['bio'] as String?,
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? bio,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
    );
  }
}
