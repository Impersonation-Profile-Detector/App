import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class DisplayContainer extends StatefulWidget {
  final dynamic user;
  final String name;
  final String imgUrl;
  const DisplayContainer(
      {super.key, this.user, required this.name, required this.imgUrl});

  @override
  State<DisplayContainer> createState() => _DisplayContainerState();
}

class _DisplayContainerState extends State<DisplayContainer> {
  String docID = uuid.v1();

  Future uploadDetails({
    required String name,
    required String imgurl,
    required String requesturl,
  }) async {
    final requestDetails =
        FirebaseFirestore.instance.collection('Insta_request').doc(docID);
    final json = {
      'Name': name,
      'User_Image': imgurl,
      'Request_Image': requesturl,
    };
    await requestDetails.set(json);
  }

  void submitRequest() async {
    try {
      uploadDetails(
          name: widget.name,
          imgurl: widget.imgUrl,
          requesturl: widget.user['profile_pic_url']);
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
                          .collection('Insta_request')
                          .doc(docID)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                color: Colors.blue,
                              ));
                        }
                        try {
                          var userDocument = snapshot.data;
                          bool result = userDocument!["Status"];
                          if (result == true) {
                            return const Icon(
                              Icons.verified_rounded,
                              color: CupertinoColors.activeGreen,
                            );
                          } else {
                            return const Icon(
                              Icons.error_outline,
                              color: CupertinoColors.systemRed,
                            );
                          }
                        } catch (e) {
                          return const SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                color: Colors.blue,
                              ));
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
