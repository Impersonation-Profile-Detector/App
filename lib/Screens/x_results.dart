import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:impersonation_detector/widgets/display_container.dart';

class XResultsPage extends StatefulWidget {
  final String username;
  const XResultsPage({Key? key, required this.username}) : super(key: key);

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

    // Request body with the username to search
    final body = {'q': widget.username};

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
        print('Full JSON Response: $responseData');

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
      appBar: AppBar(
        title: const Text('Instagram Results'),
      ),
      body: jsonData.isEmpty
          ? const Center(
              child: SizedBox(
                  height: 125, width: 125, child: CircularProgressIndicator()))
          : ListView.builder(
              //! length defined explicitly
              itemCount: 10,
              itemBuilder: (context, index) {
                final user = jsonData[index]['user'];

                return ListTile(
                  title: Text(user['name'] ?? 'N/A'),
                  subtitle: Image.network(
                    user['profile_image_url'] ?? '',
                    height: 50,
                    width: 50,
                  ),
                );
              },
            ),
    );
  }
}
