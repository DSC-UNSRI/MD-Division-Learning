import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late TextEditingController _nameController;
  late TextEditingController _bioController;

  bool _isEditing = false;
  int _avatarId = 1;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _bioController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (user != null) {
      final docRef = firestore.collection('users').doc(user!.uid);
      final snapshot = await docRef.get();
      final data = snapshot.data();

      if (data != null) {
        _nameController.text = data['name'] ?? '';
        _bioController.text = data['bio'] ?? '';
        if (data['avatarId'] != null) {
          _avatarId = data['avatarId'];
        } else {
          _avatarId = Random().nextInt(70) + 1;
          await docRef.set({'avatarId': _avatarId}, SetOptions(merge: true));
        }
      } else {
        _avatarId = Random().nextInt(70) + 1;
        await docRef.set({'avatarId': _avatarId});
      }

      setState(() {});
    }
  }

  void _saveProfile() async {
    if (user != null) {
      await firestore.collection('users').doc(user!.uid).update({
        'name': _nameController.text,
        'bio': _bioController.text,
      });

      setState(() {
        _isEditing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) return const Center(child: Text('User not logged in'));

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                'https://i.pravatar.cc/150?img=$_avatarId',
              ),
            ),
            const SizedBox(height: 8),

            // Email below avatar
            Text(
              user!.email ?? '',
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 24),

            // Name Field
            TextField(
  controller: _nameController,
  readOnly: !_isEditing,
  decoration: InputDecoration(
    labelText: 'Name',
    prefixIcon: const Icon(Icons.person_outline),
    border: const OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue),
      borderRadius: BorderRadius.circular(8),
    ),
  ),
),
            const SizedBox(height: 16),

            // Bio Field
            TextField(
              controller: _bioController,
              readOnly: !_isEditing,
              decoration: InputDecoration(
                labelText: 'Bio',
                prefixIcon: const Icon(Icons.info_outline),
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
              focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue),
      borderRadius: BorderRadius.circular(8),
    ),
            ),
            ),
            const SizedBox(height: 24),

            // Edit/Save Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: Icon(
                  _isEditing ? Icons.save : Icons.edit,
                  color: Colors.white,
                ),
                label: Text(
                  _isEditing ? 'Save' : 'Edit',
                  style: const TextStyle(color: Colors.white), // <-- White text
                ),
                onPressed: _isEditing
                    ? _saveProfile
                    : () {
                        setState(() {
                          _isEditing = true;
                        });
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
