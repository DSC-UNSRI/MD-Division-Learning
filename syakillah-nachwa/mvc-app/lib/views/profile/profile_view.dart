import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../controllers/user_controller.dart';
import '../../models/user_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserController _userController = UserController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  UserModel? _user;
  bool _isLoading = true;
  bool _isEditing = false;
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  
  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final userData = await _userController.getUserById(currentUser.uid);
        setState(() {
          _user = userData;
          if (userData != null) {
            _nameController.text = userData.name;
            _bioController.text = userData.bio;
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _updateProfile() async {
    if (_user == null) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      await _userController.updateUserProfile(
        _user!.id,
        name: _nameController.text,
        bio: _bioController.text,
      );
      
      setState(() {
        _user = _user!.copyWith(
          name: _nameController.text,
          bio: _bioController.text,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        );
        _isEditing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui profil: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if (_user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profil')),
        body: const Center(
          child: Text('Tidak dapat memuat data pengguna'),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _updateProfile,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  _user!.name.isNotEmpty ? _user!.name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Akun',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    _buildInfoRow('Email', _user!.email),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      'Dibuat pada', 
                      '${_user!.createdDateTime.day}/${_user!.createdDateTime.month}/${_user!.createdDateTime.year}'
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      'Diperbarui pada', 
                      '${_user!.updatedDateTime.day}/${_user!.updatedDateTime.month}/${_user!.updatedDateTime.year}'
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Profil',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    _isEditing
                      ? _buildEditableField('Nama', _nameController)
                      : _buildInfoRow('Nama', _user!.name),
                    const SizedBox(height: 16),
                    _isEditing
                      ? _buildEditableField('Bio', _bioController, maxLines: 3)
                      : _buildInfoRow('Bio', _user!.bio),
                  ],
                ),
              ),
            ),
            if (_isEditing)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _nameController.text = _user!.name;
                          _bioController.text = _user!.bio;
                          _isEditing = false;
                        });
                      },
                      child: const Text('Batal'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _updateProfile,
                      child: const Text('Simpan'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
  
  Widget _buildEditableField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
        ),
      ],
    );
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}