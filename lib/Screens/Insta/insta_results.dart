import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:impersonation_detector/Widgets/display_insta.dart';
import 'package:uuid/uuid.dart';

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

  Future<void> fetchData() async {
    // API endpoint and headers
    const url =
        'https://rocketapi-for-instagram.p.rapidapi.com/instagram/search';
    final headers = {
      'content-type': 'application/json',
      'X-RapidAPI-Key': 'e33db81bf2msh8b2a2c7b8cf5363p1c7fbbjsn2617a896ce97',
      'X-RapidAPI-Host': 'rocketapi-for-instagram.p.rapidapi.com',
    };

    // Request body with the username to search
    final body = {'query': widget.username};

    try {
      // Perform the HTTP POST request
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // Decode the JSON response
        final dynamic responseData = jsonDecode(response.body);
        // print('Full JSON Response: $responseData');

        // Check and extract information from the response
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
                  submitRequest(jsonData[i]['user']);
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
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        for (int i = 0; i < idList.length; i++) {
          FirebaseFirestore.instance
              .collection('Checked_List')
              .doc(idList[i])
              .delete();
        }
      },
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xff001220),
          title: const Text(
            'Instagram Results',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/waves1.png'), fit: BoxFit.cover),
          ),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Request_Details')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SizedBox(
                    height: 125,
                    width: 125,
                    child: CircularProgressIndicator(
                      color: Color(0xffffffff),
                    ),
                  ),
                );
              } else if (!snapshot.hasData) {
                return const Center(
                  child: SizedBox(
                    height: 125,
                    width: 125,
                    child: CircularProgressIndicator(
                      color: Color(0xffffffff),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<DocumentSnapshot> documents = snapshot.data!.docs;
                if (documents.isEmpty) {
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Checked_List')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (!snapshot.hasData) {
                        return const Center(
                          child: SizedBox(
                            height: 125,
                            width: 125,
                            child: CircularProgressIndicator(
                              color: Color(0xffffffff),
                            ),
                          ),
                        );
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
                  );
                } else {
                  return const Center(
                    child: SizedBox(
                      height: 125,
                      width: 125,
                      child: CircularProgressIndicator(
                        color: Color(0xffffffff),
                      ),
                    ),
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
