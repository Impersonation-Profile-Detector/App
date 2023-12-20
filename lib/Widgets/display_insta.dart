import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Container(
          padding: const EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.user['profile_pic_url'] ?? '',
                    height: 70,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        widget.user['full_name'] ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Request_Details')
                          .doc(docID)
                          .snapshots(),
                      builder: (context, snapshot) {
                        var userDocument = snapshot.data;
                        result = userDocument!["status"];
                        if (result == 'loading') {
                          return const SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                color: Colors.blue,
                              ));
                        } else if (result == 'true') {
                          return const Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: CupertinoColors.systemRed,
                              ),
                              Text('Face Matched')
                            ],
                          );
                        } else {
                          return const Row(
                            children: [
                              Icon(
                                Icons.verified_rounded,
                                color: CupertinoColors.activeGreen,
                              ),
                              Text('Face Notmatched')
                            ],
                          );
                        }
                      },
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
