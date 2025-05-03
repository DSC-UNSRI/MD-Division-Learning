import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testing/models/profile.dart';

class ProfileController {
  final CollectionReference _profileCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUser(Profile user) async {
    final newUser =
        Profile(id: user.id, name: user.name, bio: user.bio, email: user.email);

    await _profileCollection.doc(newUser.id).set(newUser.toMap());
  }

  Future<void> updateBioUser(String id, String newName, String newBio) async {
    try {
      await _profileCollection.doc(id).update({
        'name': newName,
        'bio': newBio,
      });
      print('Firestore updated');
    } catch (e) {
      print('Error updating Firestore: $e');
      rethrow;
    }
  }

  Future<Profile?> fetchProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!doc.exists) return null;

    final data = doc.data()!;
    return Profile(
      id: data['id'],
      name: data['name'],
      bio: data['bio'],
      email: data['email'],
    );
  }
}
