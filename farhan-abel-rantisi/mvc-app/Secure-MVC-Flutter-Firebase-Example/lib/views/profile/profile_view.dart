import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testing/controllers/auth_controller.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final AuthController _authController = AuthController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final user = _authController.getCurrentUser();
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = doc.data();
      if (data != null) {
        _nameController.text = data['name'] ?? '';
        _bioController.text = data['bio'] ?? '';
        _emailController.text = data['email'] ?? '';
      }
    }
    setState(() => _isLoading = false);
  }

  Future<void> updateProfile() async {
    final user = _authController.getCurrentUser();
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': _nameController.text.trim(),
        'bio': _bioController.text.trim(),
        'email': _emailController.text.trim(),
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authController.getCurrentUser();

    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: _isLoading || user == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),

              child: ListView(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/avatar.jpeg'),
                    ),
                  ),

                  SizedBox(height: 16),

                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 16),

                  TextField(
                    controller: _bioController,
                    decoration: InputDecoration(
                      labelText: 'Bio',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),

                  SizedBox(height: 16),

                  TextField(
                    readOnly: true,
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      hintText: user.email ?? '',
                    ),
                  ),
                  
                  SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: updateProfile,
                    child: Text('Save Changes'),
                  ),
                ],
              ),
            ),
    );
  }
}
