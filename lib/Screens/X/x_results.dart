import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:impersonation_detector/Widgets/display_x.dart';
import 'package:impersonation_detector/Widgets/loading.dart';
import 'package:uuid/uuid.dart';

class XResultsPage extends StatefulWidget {
  final String imgUrl;
  final String username;

  const XResultsPage({Key? key, required this.username, required this.imgUrl})
      : super(key: key);

  @override
  XResultsPageState createState() => XResultsPageState();
}

class XResultsPageState extends State<XResultsPage> {
  List<dynamic> jsonData = [];
  List<String> idList = [];
  bool delay = true;

  @override
  void initState() {
    super.initState();
    delayFunction(const Duration(seconds: 60));
    fetchData();
  }

  Future<void> delayFunction(Duration duration) async {
    await Future.delayed(duration);
    setState(() {
      delay = false;
    });
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
        reqUrl: user['avatar'].replaceFirst("normal", "400x400"),
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
    const url = 'https://twitter-api45.p.rapidapi.com/search.php';
    final headers = {
      'content-type': 'application/json',
      'X-RapidAPI-Key': 'e33db81bf2msh8b2a2c7b8cf5363p1c7fbbjsn2617a896ce97',
      'X-RapidAPI-Host': 'twitter-api45.p.rapidapi.com',
    };

    String finalUrl = '$url?query=${widget.username}&search_type=People';

    try {
      // Perform the HTTP GET request
      final response = await http.get(
        Uri.parse(finalUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Decode the JSON response
        final dynamic responseData = jsonDecode(response.body);
        // print('Full JSON Response: $responseData');

        // Check and extract information from the response
        if (responseData is Map && responseData.containsKey('timeline')) {
          final dynamic users = responseData['timeline'];
          // Update the state with the list of users

          if (users is List) {
            setState(() {
              jsonData = users;
            });

            for (int i = 0; i < jsonData.length; i++) {
              submitRequest(jsonData[i]);
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        for (int i = 0; i < idList.length; i++) {
          FirebaseFirestore.instance
              .collection(widget.username)
              .doc(idList[i])
              .delete();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xff001220),
          title: const Text(
            'X Results',
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
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        var data =
                            documents[index].data() as Map<String, dynamic>;
                        idList.add(documents[index].id);
                        return DisplayContainerX(
                            status: data['Status'],
                            user: data['UserData'],
                            id: documents[index].id);
                      },
                    );
                  }
                }
              },
            )),
      ),
    );
  }
}
