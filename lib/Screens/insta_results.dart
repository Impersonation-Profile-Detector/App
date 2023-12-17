import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:impersonation_detector/widgets/display_container.dart';

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

  @override
  void initState() {
    super.initState();
    fetchData();
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
              }
            }
          }
        }
      } else {
        // print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      // print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram Results'),
      ),
      body: jsonData.isEmpty
          ? const Center(
              child: SizedBox(
                  height: 125, width: 125, child: CircularProgressIndicator()))
          : ListView.builder(
              itemCount: jsonData.length,
              itemBuilder: (context, index) {
                final user = jsonData[index]['user'];

                return DisplayContainer(
                  user: user,
                  name: widget.username,
                  imgUrl: widget.imgUrl,
                );
              },
            ),
    );
  }
}
