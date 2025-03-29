import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                    'https://avatars.githubusercontent.com/u/148435896?v=4'),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
              ),

              Text(
                'Syakillah Nachwa',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
              ),

              Text('Email: syakillahnachwa081@gmail.com'),
              Text('WhatsApp: +62 853-7812-4125'),
              Text(
                'Information System student who loves design and product development',
                textAlign: TextAlign.center,
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
              ),

              ElevatedButton.icon(
                onPressed: () async {
                  final Uri linkedInUrl =
                      Uri.parse('https://www.linkedin.com/in/chwakillah/');
                  if (await canLaunchUrl(linkedInUrl)) {
                    await launchUrl(linkedInUrl, mode: LaunchMode.inAppWebView);
                  } else {
                    throw 'Could not launch $linkedInUrl';
                  }
                },
                icon: Icon(Icons.link),
                label: Text('LinkedIn: chwakillah'),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
              ),
              
              ElevatedButton.icon(
                onPressed: () async {
                  final Uri instagramUrl =
                      Uri.parse('https://instagram.com/chwakillah');
                  if (await canLaunchUrl(instagramUrl)) {
                    await launchUrl(instagramUrl, mode: LaunchMode.inAppWebView);
                  } else {
                    throw 'Could not launch $instagramUrl';
                  }
                },
                icon: Icon(Icons.camera_alt),
                label: Text('Instagram: @chwakillah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
