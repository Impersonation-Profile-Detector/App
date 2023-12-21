import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:impersonation_detector/widgets/display_X.dart';

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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // API endpoint and headers
    const url = 'https://twitter135.p.rapidapi.com/AutoComplete/';
    final headers = {
      'content-type': 'application/json',
      'X-RapidAPI-Key': 'e33db81bf2msh8b2a2c7b8cf5363p1c7fbbjsn2617a896ce97',
      'X-RapidAPI-Host': 'twitter135.p.rapidapi.com',
    };

    String finalUrl = '$url?q=${widget.username}';

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
        if (responseData is Map && responseData.containsKey('users')) {
          final dynamic users = responseData['users'];
          // Update the state with the list of users

          if (users is List) {
            setState(() {
              jsonData = users;
            });
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/waves1.png'), fit: BoxFit.cover),
        ),
        child: jsonData.isEmpty
            ? const Center(
                child: SizedBox(
                    height: 125,
                    width: 125,
                    child: CircularProgressIndicator(
                      color: Color(0xffffffff),
                    )))
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                //!explicitly deifined length
                itemCount: 1,
                itemBuilder: (context, index) {
                  final user = jsonData[index];
                  return DisplayContainerX(
                    name: widget.username,
                    imgUrl: widget.imgUrl,
                    user: user,
                  );
                },
              ),
      ),
    );
  }
}
