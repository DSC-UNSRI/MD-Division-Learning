// lib/views/profile/profile_view.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:testing/controllers/auth_controller.dart';
import 'package:testing/models/user_model.dart';
import 'package:testing/views/auth/login_view.dart';
import 'edit_profile_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final AuthController _authController = AuthController();
  UserModel? _userModel;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    _userModel = await _authController.getCurrentUserDetails();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    // Tampilkan dialog konfirmasi sebelum logout
    final confirmLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text('Confirm Logout',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
          content: Text('Are you sure you want to log out?',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant)),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary)),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Logout',
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmLogout == true && mounted) {
      final loggedOut = await _authController.logout();
      if (mounted) {
        if (loggedOut) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginView()),
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Logout failed. Please try again.'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  Widget _buildInfoCard(
      {required IconData icon,
      required String title,
      required String subtitle,
      Color? iconColor}) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading:
            Icon(icon, size: 28, color: iconColor ?? theme.colorScheme.primary),
        title: Text(title,
            style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7))),
        subtitle: Text(
          subtitle.isEmpty ? 'Not set' : subtitle,
          style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: colorScheme.secondary))
          : _userModel == null
              ? Center(
                  child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          color: colorScheme.error, size: 60),
                      const SizedBox(height: 16),
                      Text('Could not load profile data.',
                          style: textTheme.titleMedium,
                          textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        onPressed: _loadUserData,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.secondary),
                      )
                    ],
                  ),
                ))
              : RefreshIndicator(
                  onRefresh: _loadUserData,
                  color: colorScheme.secondary,
                  backgroundColor: colorScheme.surface,
                  child: ListView(
                    padding: const EdgeInsets.all(20.0),
                    children: [
                      const SizedBox(height: 10),
                      Center(
                        child: CircleAvatar(
                          radius: 65,
                          backgroundColor: colorScheme.surfaceVariant,
                          backgroundImage: const AssetImage(
                              'assets/images/dummy_avatar.png'),
                          child: _userModel!.name.isEmpty
                              ? Icon(Icons.person,
                                  size: 60, color: colorScheme.primary)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: Text(
                          _userModel!.name,
                          style: textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Center(
                        child: Text(
                          _userModel!.email,
                          style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onBackground.withOpacity(0.7)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildInfoCard(
                        icon: Icons.person_pin_outlined,
                        title: 'Full Name',
                        subtitle: _userModel!.name,
                        iconColor: colorScheme.primary,
                      ),
                      _buildInfoCard(
                        icon: Icons.article_outlined,
                        title: 'Bio',
                        subtitle: _userModel!.bio!,
                        iconColor: colorScheme.tertiary,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.edit_note_outlined, size: 20),
                        label: const Text('Edit Profile'),
                        onPressed: () async {
                          final result = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditProfileView(currentUser: _userModel!),
                            ),
                          );
                          if (result == true && mounted) {
                            _loadUserData();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.secondary,
                            foregroundColor: colorScheme.onSecondary,
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            textStyle:
                                textTheme.labelLarge?.copyWith(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
    );
  }
}
