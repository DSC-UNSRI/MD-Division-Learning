import 'package:flutter/material.dart';
import 'package:testing/controllers/auth_controller.dart';
import 'package:testing/controllers/profile_controller.dart';
import 'package:testing/models/profile.dart';
import 'package:testing/views/auth/login_view.dart';

class ProfileView extends StatefulWidget {
  final Profile user;

  ProfileView({super.key, required this.user});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Profile _user;
  final AuthController _authController = AuthController();

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  void _refreshProfile(Profile newUser) {
    setState(() {
      _user = newUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: bodySection(context),
    );
  }

  Widget bodySection(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header with gradient
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                ),
                SizedBox(height: 16),
                Text(
                  _user.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _user.email,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),

          // Card Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: Icon(Icons.info_outline, color: Colors.blue),
                title: Text(
                  "Bio",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  _user.bio.isNotEmpty ? _user.bio : "No bio added yet.",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),

          SizedBox(height: 24),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showEditProfileDialog(context),
                    icon: Icon(Icons.edit),
                    label: Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Confirm Logout'),
                          content: Text('Are you sure you want to log out?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                final loggedOut =
                                    await _authController.logout();
                                if (context.mounted) {
                                  if (loggedOut) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Logged out successfully'),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Failed to log out'),
                                      ),
                                    );
                                  }
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginView(),
                                    ),
                                    (route) => false,
                                  );
                                }
                              },
                              child: Text(
                                'Log out',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(Icons.logout),
                    label: Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: _user.name);
    final TextEditingController bioController =
        TextEditingController(text: _user.bio);
    final ProfileController _profileController = ProfileController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: bioController,
              decoration: InputDecoration(labelText: 'Bio'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = nameController.text.trim();
              final newBio = bioController.text.trim();

              if (newName.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Name cannot be empty')),
                );
                return;
              }

              try {
                await _profileController.updateBioUser(
                    _user.id, newName, newBio);

                final updated = await _profileController.fetchProfile();
                if (updated != null) {
                  _refreshProfile(updated);
                }

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Profile updated!')),
                );
              } catch (e) {
                print('Update Failed: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update: $e')),
                );
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        'Profile',
        style: TextStyle(
            color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );
  }
}
