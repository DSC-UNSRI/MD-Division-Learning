import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserController {
  final CollectionReference _usersCollection = 
      FirebaseFirestore.instance.collection('users');

  Future<void> saveUserToFirestore(UserModel userModel) async {
    try {
      await _usersCollection.doc(userModel.id).set(userModel.toMap());
    } catch (e) {
      throw Exception('Failed to save user data: $e');
    }
  }

  Future<UserModel?> getUserById(String userId) async {
    try {
      final docSnapshot = await _usersCollection.doc(userId).get();
      if (docSnapshot.exists && docSnapshot.data() != null) {
        return UserModel.fromMap(docSnapshot.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  Future<void> updateUserProfile(String userId, {String? name, String? bio}) async {
    try {
      final userData = <String, dynamic>{
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      };

      if (name != null) {
        userData['name'] = name;
      }

      if (bio != null) {
        userData['bio'] = bio;
      }

      await _usersCollection.doc(userId).update(userData);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }
}