// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // --- Data Profil ---
  final String profileName = "Muhammad Arief Pratama";
  final String profileDescription =
      "A passionate developer with experience in Flutter and other mobile technologies. "
      "Loves to create mobile applications that provide excellent user experiences. "
      "Currently exploring new ways to innovate and contribute to open source projects.";
  // final String avatarInitial = "A"; // Tidak digunakan lagi jika menggunakan gambar
  final String avatarImagePath =
      "assets/images/Arief.jpeg"; // Path ke gambar avatar Anda
  final String contactNumber = "+62895609563448";
  final String defaultAddress =
      "Permata Baru, Ogan Ilir, Sumatera Selatan, Indonesia";

  // --- URL Sosial Media ---
  final String githubUrl = "https://github.com/ariefff666";
  final String linkedinUrl =
      "https://linkedin.com/in/muhammad-arief-pratama-26762a294";
  final String instagramUrl = "https://instagram.com/ariefff666";

  bool _imageError = false;

  // --- Fungsi untuk membuka URL ---
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak dapat membuka $urlString')),
        );
      }
      debugPrint('Could not launch $urlString');
    }
  }

  // --- Fungsi untuk Tombol Aksi ---
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (!await launchUrl(launchUri)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tidak dapat melakukan panggilan ke $phoneNumber'),
          ),
        );
      }
      debugPrint('Could not launch $launchUri');
    }
  }

  Future<void> _openMaps(String address) async {
    final String googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}";
    if (!await launchUrl(
      Uri.parse(googleMapsUrl),
      mode: LaunchMode.externalApplication,
    )) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak dapat membuka peta untuk $address')),
        );
      }
      debugPrint('Could not launch $googleMapsUrl');
    }
  }

  Future<void> _shareProfile() async {
    final String shareText =
        "Lihat profil developer ini: $profileName\nGitHub: $githubUrl";
    await Share.share(shareText, subject: 'Profil Developer: $profileName');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // final primaryColor = Theme.of(context).primaryColorDark; // Tidak digunakan di avatar lagi

    return Scaffold(
      appBar: AppBar(title: const Text('About Developer'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            _buildAvatar(), // Tidak perlu parameter warna lagi
            const SizedBox(height: 20),
            _buildProfileName(textTheme),
            const SizedBox(height: 12),
            _buildProfileDescription(textTheme),
            const SizedBox(height: 24),
            _buildSocialMediaButtons(),
            const SizedBox(height: 40),
            _buildActionSection(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 75,
      backgroundColor: Colors.white.withOpacity(0.2),
      backgroundImage: AssetImage(avatarImagePath),
      onBackgroundImageError:
          _imageError
              ? null
              : (exception, stackTrace) {
                setState(() {
                  _imageError = true;
                });
                debugPrint('Error loading avatar image: $exception');
              },
      child:
          _imageError
              ? Icon(Icons.person, size: 70, color: Colors.grey.shade600)
              : null,
    );
  }

  Widget _buildProfileName(TextTheme textTheme) {
    return Text(
      profileName,
      style: textTheme.titleLarge?.copyWith(fontSize: 26),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildProfileDescription(TextTheme textTheme) {
    return Text(
      profileDescription,
      textAlign: TextAlign.center,
      style: textTheme.bodyMedium?.copyWith(
        fontSize: 16,
        height: 1.5,
        color: Theme.of(
          context,
        ).colorScheme.onBackground.withOpacity(0.85), // Gunakan warna tema
      ),
    );
  }

  Widget _buildSocialMediaButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _SocialButton(
          icon: FontAwesomeIcons.github,
          onPressed: () => _launchURL(githubUrl),
        ),
        const SizedBox(width: 20),
        _SocialButton(
          icon: FontAwesomeIcons.linkedinIn,
          onPressed: () => _launchURL(linkedinUrl),
        ),
        const SizedBox(width: 20),
        _SocialButton(
          icon: FontAwesomeIcons.instagram,
          onPressed: () => _launchURL(instagramUrl),
        ),
      ],
    );
  }

  Widget _buildActionSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceVariant.withOpacity(0.5), // Gunakan warna tema
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _ActionItem(
            icon: Icons.call_outlined,
            label: "CALL",
            onTap: () => _makePhoneCall(contactNumber),
          ),
          _ActionItem(
            icon: Icons.directions_outlined,
            label: "ROUTE",
            onTap: () => _openMaps(defaultAddress),
          ),
          _ActionItem(
            icon: Icons.share_outlined,
            label: "SHARE",
            onTap: _shareProfile,
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _SocialButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      splashColor: Theme.of(
        context,
      ).colorScheme.primary.withOpacity(0.3), // Gunakan warna tema
      highlightColor: Theme.of(
        context,
      ).colorScheme.primary.withOpacity(0.2), // Gunakan warna tema
      child: Container(
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.surface.withOpacity(0.8), // Gunakan warna tema
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: FaIcon(
          icon,
          color: Theme.of(context).colorScheme.onSurface, // Gunakan warna tema
          size: 24,
        ),
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.onTap, // Tambahkan key
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      splashColor: Theme.of(
        context,
      ).colorScheme.primary.withOpacity(0.2), // Gunakan warna tema
      highlightColor: Theme.of(
        context,
      ).colorScheme.primary.withOpacity(0.1), // Gunakan warna tema
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 28,
            ), // Gunakan warna tema
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Theme.of(context).colorScheme.onSurfaceVariant
                    .withOpacity(0.95), // Gunakan warna tema
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
