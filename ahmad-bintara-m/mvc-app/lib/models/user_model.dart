// lib/models/user_model.dart

class UserModel {
  String userId;
  String email;
  String name;
  String profilePicture;
  DateTime createdAt;
  DateTime updatedAt;

  // Konstruktor
  UserModel({
    required this.userId,
    required this.email,
    required this.name,
    required this.profilePicture,
    required this.createdAt,
    required this.updatedAt,
  });

  // Mengubah UserModel menjadi Map untuk disimpan di Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'profilePicture': profilePicture,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Mengambil UserModel dari Map yang diambil dari Firestore
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'],
      email: map['email'],
      name: map['name'],
      profilePicture: map['profilePicture'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}
