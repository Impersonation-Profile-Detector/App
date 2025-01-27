import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:impersonation_detector/Widgets/display_insta.dart';
import 'package:impersonation_detector/Widgets/loading.dart';
import 'package:impersonation_detector/var.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:uuid/uuid.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class InstaResultsPage extends StatefulWidget {
  final String username;
  final String imgUrl;

  const InstaResultsPage(
      {Key? key, required this.username, required this.imgUrl})
      : super(key: key);

  @override
  InstaResultsPageState createState() => InstaResultsPageState();
}

class InstaResultsPageState extends State<InstaResultsPage> {
  List<dynamic> jsonData = [];
  List<String> idList = [];
  bool delay = true;
  Uint8List? _imageFile;
  ScreenshotController screenshotController = ScreenshotController();

  Future<bool> isCollectionEmpty(String collectionPath) async {
    QuerySnapshot<Map<String, dynamic>> collection =
        await FirebaseFirestore.instance.collection(collectionPath).get();

    return collection.docs.isEmpty;
  }

  Future uploadDetails({
    required String name,
    required String imgurl,
    required String reqUrl,
    required dynamic user,
    required String docID,
  }) async {
    final requestDetails =
        FirebaseFirestore.instance.collection('Request_Details').doc(docID);
    final json = {
      'Name': name,
      'User_Image': imgurl,
      'Req_Image': reqUrl,
      'UserData': user
    };
    await requestDetails.set(json);
  }

  Future<void> submitRequest(dynamic user) async {
    var uuid = const Uuid();
    String docD = uuid.v1();
    try {
      uploadDetails(
        name: widget.username,
        imgurl: widget.imgUrl,
        reqUrl: user['profile_pic_url'],
        user: user,
        docID: docD,
      );
    } catch (e) {
      if (!mounted) return;
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

  Future<void> saveImageToGallery(Uint8List imageBytes) async {
    try {
      // Save image to gallery
      final result = await ImageGallerySaver.saveImage(imageBytes);

      if (result['isSuccess']) {
        // Image saved successfully
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image saved to gallery'),
          ),
        );
      } else {
        // Failed to save image
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save image: ${result['errorMessage']}'),
          ),
        );
      }
    } catch (e) {
      // Error occurred while saving image
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving image: $e'),
        ),
      );
    }
  }

  Future<void> exportFirestoreDataToCsv() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection(widget.username).get();
      String csvData = '';
      csvData += 'Name,ProfileImage,ProfileUrl,Accuracy\n';
      for (var doc in querySnapshot.docs) {
        String profileLink =
            "https://www.instagram.com/${doc['UserData']['username']}";
        csvData +=
            '${doc['Name']},${doc['Req_Image']},$profileLink,${((1 - doc['Status']) * 100).ceil()}%\n';
      }
      Directory? directory = Directory("/storage/emulated/0/Download");

      String filePath = '${directory.path}/nerprofile_${widget.username}_insta.csv';

      File file = File(filePath);
      await file.writeAsString(csvData);
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('CSV File saved at: $filePath'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('CSV Error saving file: $e'),
        ),
      );
    }
  }

  Future<void> delayFunction(Duration duration) async {
    await Future.delayed(duration);
    setState(() {
      delay = false;
    });
  }

  Future<void> fetchData() async {
    // API endpoint and headers
    const url =
        'https://rocketapi-for-instagram.p.rapidapi.com/instagram/search';
    final headers = {
      'content-type': 'application/json',
      'X-RapidAPI-Key': '8db0e54e94msh98b37a582a2adefp182a93jsnf53067009cea',
      'X-RapidAPI-Host': 'rocketapi-for-instagram.p.rapidapi.com',
    };

    // Request body with the username to search
    final body = {'query': widget.username};

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);

        if (responseData is Map && responseData.containsKey('response')) {
          final dynamic responseInfo = responseData['response'];

          if (responseInfo is Map && responseInfo.containsKey('body')) {
            final dynamic responseBody = responseInfo['body'];

            if (responseBody is Map && responseBody.containsKey('users')) {
              final dynamic users = responseBody['users'];

              // Update the state with the list of users
              if (users is List) {
                setState(() {
                  jsonData = users;
                });
                for (int i = 0; i < jsonData.length; i++) {
                  if (i < 30) {
                    submitRequest(jsonData[i]['user']);
                  }
                }
              }
            }
          }
        }
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Request failed with status: ${response.statusCode}'),
          ),
        );
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString(),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    delayFunction(const Duration(seconds: loadingDelay));
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async {
        var collection = FirebaseFirestore.instance.collection(widget.username);
        var snapshots = await collection.get();
        for (var doc in snapshots.docs) {
          await doc.reference.delete();
        }
      },
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () async {
                await exportFirestoreDataToCsv();
              },
              icon: const Icon(
                Icons.file_download_outlined,
              ),
            )
          ],
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xff001220),
          title: const Text(
            'Instagram Results',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Screenshot(
          controller: screenshotController,
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/waves1.png'), fit: BoxFit.cover),
            ),
            child: delay
                ? const Center(
                    child: Loading(),
                  )
                : StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection(widget.username)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (!snapshot.hasData) {
                        return const Center(child: Loading());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<DocumentSnapshot> documents = snapshot.data!.docs;
                        if (documents.isEmpty) {
                          return const Center(
                            child: Text(
                              "No matches found ",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              var data = documents[index].data()
                                  as Map<String, dynamic>;
                              idList.add(documents[index].id);
                              return DisplayContainerInsta(
                                  status: data['Status'],
                                  user: data['UserData'],
                                  id: documents[index].id);
                            },
                          );
                        }
                      }
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
