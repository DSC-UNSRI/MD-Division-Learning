import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileView extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: user == null
            ? Center(child: Text('No user data found.'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blueGrey,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text("Email:", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(user!.email ?? 'No email'),
                  SizedBox(height: 16),
                  Text("UID:", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(user!.uid),
                ],
              ),
      ),
    );
  }
}
