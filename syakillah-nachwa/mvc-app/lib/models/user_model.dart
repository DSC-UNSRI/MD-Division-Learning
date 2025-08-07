class UserModel {
  final String id;
  final String name;
  final String email;
  final String bio;
  final int createdAt;
  final int updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.bio,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'bio': bio,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'] ?? '',
      createdAt: map['createdAt'] ?? 0,
      updatedAt: map['updatedAt'] ?? 0,
    );
  }

  DateTime get createdDateTime => DateTime.fromMillisecondsSinceEpoch(createdAt);
  DateTime get updatedDateTime => DateTime.fromMillisecondsSinceEpoch(updatedAt);

  UserModel copyWith({
    String? name,
    String? bio,
    int? updatedAt,
  }) {
    return UserModel(
      id: this.id,
      name: name ?? this.name,
      email: this.email,
      bio: bio ?? this.bio,
      createdAt: this.createdAt,
      updatedAt: updatedAt ?? DateTime.now().millisecondsSinceEpoch,
    );
  }
}