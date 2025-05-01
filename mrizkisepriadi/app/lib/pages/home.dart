import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/models/sosmed_model.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatelessWidget {
  Home({super.key});

  List<SosmedModel> sosmeds = SosmedModel.getSosmeds();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: bodySection(),
    );
  }

  Container bodySection() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(height: 16),
          ClipOval(
            child: Image.asset(
              'assets/photos/myphoto.jpeg',
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Muhammad Rizki Sepriadi',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'A student in Informatics Engineering at Sriwijaya University with a strong passion for mobile development and technology innovation.',
            style: TextStyle(color: Colors.black, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 100,
            child: Center(
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: sosmeds.length,
                separatorBuilder: (context, index) => SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      final Uri url = Uri.parse(sosmeds[index].linkPath);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url,
                            mode: LaunchMode.externalApplication);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Tidak bisa membuka ${sosmeds[index].sosmed}')),
                        );
                      }
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey.shade200,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            sosmeds[index].iconPath,
                            height: 50,
                            width: 50,
                          ),
                          SizedBox(height: 8),
                          Text(
                            sosmeds[index].sosmed,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        'About Me',
        style: TextStyle(
            color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );
  }
}
