import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SimpleProfilePage extends StatelessWidget {
  SimpleProfilePage({super.key});

  // i think i will make it more clean next time, for now imma just put all the abstraction here
  final Color liGreenAcc = Colors.lightGreenAccent;
  final Color bl87 = Colors.black87;

  final String _profileImagePath = 'assets/glorp_car.jpg';
  final double _constSize = 96.0;

  final String _devName = 'Fachry Ghifary';
  final String _aboutDev =
      'A CS undergraduate majoring in Informatics Engineering batch 2023. Currently is a member of GDGoC UNSRI on Mobile Development division batch 2024/2025. As of now would like to learn more about mobdev(obviously) and image processing.';

  final Uri _githubUrl = Uri.parse('https://github.com/githubbingry');
  final Uri _instagramUrl = Uri.parse('https://www.instagram.com/fchry_4/');
  final Uri _linkedinUrl =
      Uri.parse('https://www.linkedin.com/in/fachry-ghifary-563b4b296/');

  final String _githubText = 'Check out my GitHub! (its a dryland)';
  final String _instagramText = 'Check out my Instagram! (also a dryland)';
  final String _linkedinText = 'Check out my LinkedIn! (defo a dryland)';

  Future<void> _launchGithubUrl() async {
    if (!await launchUrl(_githubUrl)) {
      throw Exception('Could not launch $_githubUrl');
    }
  }

  Future<void> _launchInstagramUrl() async {
    if (!await launchUrl(_instagramUrl)) {
      throw Exception('Could not launch $_instagramUrl');
    }
  }

  Future<void> _launchLinkedinUrl() async {
    if (!await launchUrl(_linkedinUrl)) {
      throw Exception('Could not launch $_linkedinUrl');
    }
  }

  Widget _profilePic() {
    return CircleAvatar(
      radius: _constSize,
      backgroundColor: liGreenAcc,
      child: Padding(
        padding: EdgeInsets.all(_constSize / 12), // Border radius
        child: ClipOval(
          child: Image(
            image: AssetImage(_profileImagePath),
          ),
        ),
      ),
    );
  }

  List<Widget> _devDesc() {
    return [
      Text(
        _devName,
        style: TextStyle(
          color: bl87,
          fontSize: _constSize / 4,
          fontWeight: FontWeight.bold,
        ),
      ),
      Padding(
        padding: EdgeInsets.all(_constSize / 4),
        child: Text(
          _aboutDev,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: bl87,
            fontSize: _constSize / 8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ];
  }

  List<Widget> _socialMedia() {
    return [
      ElevatedButton(
        onPressed: _launchGithubUrl,
        style: ElevatedButton.styleFrom(
          backgroundColor: liGreenAcc,
          foregroundColor: bl87,
        ),
        child: Text(_githubText),
      ),
      ElevatedButton(
        onPressed: _launchInstagramUrl,
        style: ElevatedButton.styleFrom(
          backgroundColor: liGreenAcc,
          foregroundColor: bl87,
        ),
        child: Text(_instagramText),
      ),
      ElevatedButton(
        onPressed: _launchLinkedinUrl,
        style: ElevatedButton.styleFrom(
          backgroundColor: liGreenAcc,
          foregroundColor: bl87,
        ),
        child: Text(_linkedinText),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: _constSize,
          ),
          _profilePic(),
          SizedBox(
            height: _constSize / 2,
          ),
          ..._devDesc(),
          ..._socialMedia(),
        ],
      ),
    );
  }
}
