import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../controllers/auth_controller.dart';
import '../../models/user_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final AuthController _authController = AuthController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  
  bool _isLoading = true;
  bool _isEditing = false;
  bool _isSaving = false;
  UserModel? _user;
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    if (_currentUser != null) {
      final userData = await _authController.getUserData(_currentUser!.uid);
      
      if (userData != null) {
        setState(() {
          _user = userData;
          _nameController.text = userData.name;
          _bioController.text = userData.bio;
        });
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveProfile() async {
    if (_currentUser == null) return;
    
    setState(() {
      _isSaving = true;
    });

    final success = await _authController.updateUserProfile(
      _currentUser!.uid,
      name: _nameController.text,
      bio: _bioController.text,
    );

    setState(() {
      _isSaving = false;
      _isEditing = false;
      
      if (success && _user != null) {
        _user = UserModel(
          id: _user!.id,
          name: _nameController.text,
          bio: _bioController.text,
          email: _user!.email,
        );
      }
    });

    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Profile updated successfully' : 'Failed to update profile'),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        backgroundColor: Colors.blue.shade700,
        actions: [
          if (!_isEditing && !_isLoading)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue.shade50, Colors.white],
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.blue.shade200,
                      child: Icon(
                        Icons.person,
                        size: 70,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_isEditing) ...[
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  labelText: 'Name',
                                  prefixIcon: Icon(Icons.person),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _bioController,
                                decoration: InputDecoration(
                                  labelText: 'Bio',
                                  prefixIcon: Icon(Icons.info),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                maxLines: 3,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          _isEditing = false;
                                          _nameController.text = _user?.name ?? '';
                                          _bioController.text = _user?.bio ?? '';
                                        });
                                      },
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.blue.shade700,
                                        padding: EdgeInsets.symmetric(vertical: 12),
                                      ),
                                      child: Text('Cancel'),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _isSaving ? null : _saveProfile,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue.shade700,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(vertical: 12),
                                      ),
                                      child: _isSaving
                                          ? SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : Text('Save'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: Icon(Icons.person, color: Colors.blue.shade700),
                                title: Text('Name'),
                                subtitle: Text(
                                  _user?.name ?? 'Not set',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Divider(),
                              ListTile(
                                leading: Icon(Icons.email, color: Colors.blue.shade700),
                                title: Text('Email'),
                                subtitle: Text(
                                  _user?.email ?? _currentUser?.email ?? 'Not available',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Divider(),
                              ListTile(
                                leading: Icon(Icons.info, color: Colors.blue.shade700),
                                title: Text('Bio'),
                                subtitle: Text(
                                  _user?.bio.isNotEmpty == true ? _user!.bio : 'No bio provided',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontStyle: _user?.bio.isEmpty == true
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
} 