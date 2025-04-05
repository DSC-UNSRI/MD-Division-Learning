import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Profile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Profile'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _buildProfileSection(),
            const SizedBox(height: 12),
            _buildInfoSection('Email', 'farhanrantisi55@gmail.com'),
            _buildInfoSection('Phone Number', '088269639683'),
            _buildInfoSection('Instagram', '@frhnabel_'),
            _buildInfoSection('LinkedIn', 'Farhan Abel Rantisi'),
            _buildInfoSection('GitHub', 'FarhanAbelRantisi'),
            const SizedBox(height: 24),
            _buildSocialMediaRow(),
            
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),

    
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              ClipOval(
                child: Image.asset(
                  'assets/images/Foto_Farhan Abel Rantisi.jpg',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 20),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Farhan Abel Rantisi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 5),

                  Text('Informatics Engineering 2022'),

                  SizedBox(height: 5),

                  Text('Sriwijaya University'),
                ],
              ),
            ],
          ),

          const SizedBox(height: 5),

          const Divider(color: Colors.grey, thickness: 1),

          const SizedBox(height: 5),

          const Text(
            'A sixth-semester Informatics Engineering student at Sriwijaya University with a strong interest in Mobile Development and UI/UX Design.',
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(content),
          ),
        ],
      ),

    );
  }

  Widget _buildSocialMediaRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        _buildClickableLogo('assets/images/logo_github.jpg', 'https://github.com/FarhanAbelRantisi'),

        const SizedBox(width: 10),

        _buildClickableLogo('assets/images/logo_instagram.png', 'https://instagram.com/frhnabel_'),

        const SizedBox(width: 10),

        _buildClickableLogo('assets/images/logo_linkedin.jpg', 'https://linkedin.com/in/farhanabelrantisi'),
      ],
    );
  }

  Widget _buildClickableLogo(String assetPath, String url) {
    return GestureDetector(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          debugPrint("Could not launch $url");
        }
      },

      child: Image.asset(
        assetPath,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
      ),
    );
    
  }
}