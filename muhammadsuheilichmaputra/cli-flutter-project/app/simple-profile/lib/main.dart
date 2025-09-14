import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MaterialApp(
  home: Home(),
));

class Home extends StatelessWidget {
  const Home({super.key});
  final double profileHeight = 120;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Container(
              child: profileImage(),
            ),
          ),
          Text("Muhammad Suheil",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),),
          Text("Beginner Mobile Developer",
          style: TextStyle(
            fontSize: 16),
            ),
          Column(
            children: [
              aboutMe(),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Text('Social Media',),
              ),
              socialMedia(),
            ],
          ),
          
        ],
      ),
    )
  );
  }

  Widget profileImage() => CircleAvatar(
    radius: profileHeight /2,
    // backgroundColor: Colors.grey[400],
    backgroundImage: AssetImage('assets/NEWLOGO.png'),
  );

  Widget aboutMe() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("About Me",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          ),
          
        ),
        Text("Saya adalah seorang mahasiswa semester 4 Teknik Informatika Universitas Sriwijaya dan sekarang bergabung ke dalam Google Development Group on Campus (GDGoC) UNSRI",
            style: TextStyle(
              color: Colors.grey[400]),
              textAlign: TextAlign.left,
              ),
      ],
    ),
  );

  Widget buildSocialIcon(IconData icon) => CircleAvatar(
    radius: 25,
    child: InkWell(
      onTap: (){},
      child: Center(
        child: Icon(
          icon,
          size: 32,),
      ),
    ),
  );
  Widget socialMedia() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ElevatedButton(
        onPressed: () async {
            try {
              final Uri instagramUrl = Uri.parse('https://instagram.com/suheilputraa');
              await launchUrl(instagramUrl, mode: LaunchMode.externalApplication);
            } catch (e) {
              debugPrint('Error launching URL: $e');
            }
          }, 
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(), 
        padding: EdgeInsets.all(10),
        backgroundColor: const Color.fromARGB(255, 222, 222, 222)
      ),
      child: Icon(
        size: 40,
        FontAwesomeIcons.instagram,
        color: Colors.white,)),
        const SizedBox(width: 40),
      
        ElevatedButton(
          onPressed: () async {
            try {
              final Uri instagramUrl = Uri.parse('https://instagram.com/suheilputraa');
              await launchUrl(instagramUrl, mode: LaunchMode.externalApplication);
            } catch (e) {
              debugPrint('Error launching URL: $e');
            }
          }, 
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(), 
            padding: EdgeInsets.all(10),
            backgroundColor: const Color.fromARGB(255, 222, 222, 222)
          ),
          child: Icon(
            size: 40,
            FontAwesomeIcons.github,
            color: Colors.white,
          ),
        ),

      const SizedBox(width: 40),

      ElevatedButton(
        onPressed: () async {
            try {
              final Uri linkedinUrl = Uri.parse('https://www.linkedin.com/in/muhammadsuheilichmaputra/');
              await launchUrl(linkedinUrl, mode: LaunchMode.externalApplication);
            } catch (e) {
              debugPrint('Error launching URL: $e');
            }
          }, 
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(), 
        padding: EdgeInsets.all(10),
        backgroundColor: const Color.fromARGB(255, 222, 222, 222)
      ),
      child: Icon(
        size: 40,
        FontAwesomeIcons.linkedin,
        color: Colors.white,)),
    ],
  );
}