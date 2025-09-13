class Profile {
  String id;
  String name;
  String bio;
  String email;

  Profile({
    required this.id,
    required this.name,
    required this.email,
    this.bio = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'email': email,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
        id: map['id'], name: map['name'], bio: map['bio'], email: map['email']);
  }
}
