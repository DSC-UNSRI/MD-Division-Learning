// lib/views/profile/edit_profile_view.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:testing/controllers/auth_controller.dart';
import 'package:testing/models/user_model.dart';

class EditProfileView extends StatefulWidget {
  final UserModel currentUser;

  const EditProfileView({super.key, required this.currentUser});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final AuthController _authController = AuthController();
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentUser.name);
    _bioController = TextEditingController(
        text: widget.currentUser.bio ?? ''); // Handle null bio
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      final success = await _authController.updateUserProfile(
        widget.currentUser.id,
        _nameController.text.trim(),
        _bioController.text.trim(),
      );
      if (mounted) {
        // Pastikan widget masih dalam tree sebelum memanggil setState atau ScaffoldMessenger
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'Profile updated successfully!'
                : 'Failed to update profile. Please try again.'),
            backgroundColor: success
                ? Colors.green[700]
                : Theme.of(context).colorScheme.error,
          ),
        );
        if (success) {
          Navigator.pop(
              context, true); // Kirim 'true' untuk menandakan ada perubahan
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        const AssetImage('assets/images/dummy_avatar.png'),
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  'Update Your Information',
                  style: textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Make changes to your name and bio below.',
                  style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onBackground.withOpacity(0.7)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Name Text Field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                    prefixIcon: Icon(Icons.person_outline,
                        color: colorScheme.onSurfaceVariant),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide
                          .none, // Hilangkan border default jika filled
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                          color: colorScheme.outlineVariant.withOpacity(0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: colorScheme.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceVariant.withOpacity(0.5),
                  ),
                  style: textTheme.bodyLarge
                      ?.copyWith(color: colorScheme.onSurface),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Bio Text Field
                TextFormField(
                  controller: _bioController,
                  decoration: InputDecoration(
                    labelText: 'Bio',
                    hintText: 'Tell us a little about yourself...',
                    prefixIcon: Icon(Icons.article_outlined,
                        color: colorScheme.onSurfaceVariant),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                          color: colorScheme.outlineVariant.withOpacity(0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: colorScheme.primary, width: 2),
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceVariant.withOpacity(0.5),
                    alignLabelWithHint: true,
                  ),
                  style: textTheme.bodyLarge
                      ?.copyWith(color: colorScheme.onSurface),
                  maxLines: 4,
                  maxLength: 150,
                ),
                const SizedBox(height: 32),

                // Save Button
                _isSaving
                    ? Center(
                        child: CircularProgressIndicator(
                            color: colorScheme.secondary))
                    : ElevatedButton.icon(
                        icon: const Icon(Icons.save_alt_outlined, size: 20),
                        label: const Text('Save Changes'),
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          textStyle:
                              textTheme.labelLarge?.copyWith(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
