import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Page',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Picture
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            // Name and Role
            const Text(
              'M Haikal Ash Shiddiq',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Mobile Developer',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            // Contact Information
            const ProfileSection(
              title: 'Contact Information',
              children: [
                ProfileInfoRow(icon: Icons.email, text: 'haikalashshiddiq12@gmail.com'),
                ProfileInfoRow(icon: Icons.phone, text: '+62 895-1353-8871'),
                ProfileInfoRow(icon: Icons.location_on, text: 'Palembang, Indonesia'),
              ],
            ),
            const SizedBox(height: 20),
            // Bio
            const ProfileSection(
              title: 'About Me',
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'I am a passionate Mobile developer with a keen interest in creating beautiful and functional mobile applications. I love learning new technologies and solving complex problems.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Social Media
            const ProfileSection(
              title: 'Social Media',
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialMediaButton(icon: Icons.facebook, label: 'Facebook'),
                    SizedBox(width: 20),
                    SocialMediaButton(icon: Icons.link, label: 'LinkedIn'),
                    SizedBox(width: 20),
                    SocialMediaButton(icon: Icons.code, label: 'GitHub'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ProfileSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ...children,
      ],
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const ProfileInfoRow({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class SocialMediaButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const SocialMediaButton({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(icon),
          color: Colors.blue,
        ),
        Text(label),
      ],
    );
  }
}
