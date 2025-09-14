// lib/views/profile_view.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import 'package:flutter/foundation.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final AuthController _authController = AuthController();
  Future<UserModel?>? _userDataFuture;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    setState(() {
      _userDataFuture = _authController.getCurrentUserData();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _showEditProfileDialog(UserModel currentUser) async {
    _nameController.text = currentUser.name;
    _bioController.text = currentUser.bio;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _bioController,
                  decoration: const InputDecoration(labelText: 'Bio'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                try {
                  await _authController.updateUserProfile(
                    name: _nameController.text,
                    bio: _bioController.text,
                  );
                  Navigator.of(context).pop(); 
                  _loadUserData(); 
                  if (mounted) {
                     ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated successfully!')),
                    );
                  }
                } catch (e) {
                   if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to update profile: ${e.toString()}')),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder<UserModel?>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (kDebugMode) {
            print("[PROFILE_VIEW_DEBUG] FutureBuilder state: ${snapshot.connectionState}");
            print("[PROFILE_VIEW_DEBUG] Has Data: ${snapshot.hasData}");
            print("[PROFILE_VIEW_DEBUG] Data: ${snapshot.data}");
            print("[PROFILE_VIEW_DEBUG] Has Error: ${snapshot.hasError}");
            print("[PROFILE_VIEW_DEBUG] Error: ${snapshot.error}");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text(snapshot.error?.toString() ?? 'Failed to load user data. Please try again.'),
            );
          }

          final user = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // 1. Dummy Avatar
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade300,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Text('Name:', style: Theme.of(context).textTheme.titleMedium),
                Text(user.name, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 16),

                Text('Email:', style: Theme.of(context).textTheme.titleMedium),
                Text(user.email, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 16),

                Text('Bio:', style: Theme.of(context).textTheme.titleMedium),
                Text(user.bio.isEmpty ? 'No bio set.' : user.bio, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 24),

                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                    onPressed: () {
                      _showEditProfileDialog(user);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}