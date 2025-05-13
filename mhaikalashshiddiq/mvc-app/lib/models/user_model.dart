class UserModel {
  final String id;
  String name;
  String bio;
  final String email;

  UserModel({
    required this.id,
    required this.name,
    this.bio = '',
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      bio: map['bio'] ?? '',
      email: map['email'] ?? '',
    );
  }
} 