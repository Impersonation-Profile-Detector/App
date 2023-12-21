import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:url_launcher/url_launcher.dart';

var uuid = const Uuid();

class DisplayContainerInsta extends StatefulWidget {
  final dynamic user;
  final String name;
  final String imgUrl;
  const DisplayContainerInsta(
      {super.key, this.user, required this.name, required this.imgUrl});

  @override
  State<DisplayContainerInsta> createState() => _DisplayContainerInstaState();
}

class _DisplayContainerInstaState extends State<DisplayContainerInsta> {
  String docID = uuid.v1();
  String result = 'loading';

  Future uploadDetails({
    required String name,
    required String imgurl,
    required String requesturl,
    required String status,
  }) async {
    final requestDetails =
        FirebaseFirestore.instance.collection('Request_Details').doc(docID);
    final json = {
      'Name': name,
      'User_Image': imgurl,
      'Request_Image': requesturl,
      'status': status,
    };
    await requestDetails.set(json);
  }

  void submitRequest() async {
    try {
      uploadDetails(
          name: widget.name,
          imgurl: widget.imgUrl,
          requesturl: widget.user['profile_pic_url'],
          status: 'loading');
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    submitRequest();
    super.initState();
  }

  @override
  void dispose() {
    FirebaseFirestore.instance
        .collection('Request_Details')
        .doc(docID)
        .delete();
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
              width: 20,
            ),
            SizedBox(
              width: 150,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user['full_name'] ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        String userN = widget.user['username'];
                        launchUrl(Uri.parse(
                            "https://www.instagram.com/$userN"));
                      },
                      child: const Text(
                        'Profile Link',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Request_Details')
                    .doc(docID)
                    .snapshots(),
                builder: (context, snapshot) {
                  try {
                    var userDocument = snapshot.data;
                    result = userDocument!["status"];
                    if (result == 'loading') {
                      return const SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            color: Color(0xffC62368),
                          ));
                    } else if (result == 'true') {
                      return SizedBox(
                        height: 36,
                        width: 36,
                        child: Tab(
                          icon: Image.asset('assets/Spy.png'),
                        ),
                      );
                    } else {
                      return const SizedBox(
                        height: 36,
                        width: 36,
                        child: Icon(
                          Icons.verified_user,
                          color: CupertinoColors.activeGreen,
                        ),
                      );
                    }
                  } catch (e) {
                    return const SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          color: Color(0xffC62368),
                        ));
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
