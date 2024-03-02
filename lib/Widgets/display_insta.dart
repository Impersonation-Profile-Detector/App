import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DisplayContainerInsta extends StatefulWidget {
  final dynamic user;
  final double status;
  final String id;
  const DisplayContainerInsta(
      {super.key, this.user, required this.status, required this.id});

  @override
  State<DisplayContainerInsta> createState() => _DisplayContainerInstaState();
}

class _DisplayContainerInstaState extends State<DisplayContainerInsta> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(12),
        width: 320,
        height: 85,
        decoration: BoxDecoration(
          color: const Color(0xffd9d9d9),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 60,
              width: 60,
              child: AvatarGlow(
                startDelay: const Duration(milliseconds: 1000),
                glowColor: Theme.of(context).colorScheme.tertiary,
                glowShape: BoxShape.circle,
                animate: true,
                glowCount: 1,
                glowRadiusFactor: 0.2,
                curve: Curves.fastOutSlowIn,
                child: Material(
                  elevation: 8.0,
                  shape: const CircleBorder(),
                  color: Colors.transparent,
                  child: CircleAvatar(
                    backgroundImage:
                        NetworkImage(widget.user['profile_pic_url'] ?? ''),
                    radius: 30.0,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user['full_name'] ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      String userN = widget.user['username'];
                      launchUrl(Uri.parse("https://www.instagram.com/$userN"));
                    },
                    child: const Text(
                      'Profile Link',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                ],
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 12),
            //   child: Text(
            //     "${((1 - widget.status) * 100).ceil()}%",
            //     style: const TextStyle(
            //       fontSize: 16,
            //       color: Colors.red,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
