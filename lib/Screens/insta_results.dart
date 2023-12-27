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
  int currentPage = 1;

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
<<<<<<< Updated upstream
      appBar: AppBar(
        title: const Text('Instagram Results'),
=======
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
            : Column(children: [
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    //! length defined explicitly
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      final actualIndex = (currentPage - 1) * 6 + index;
                      if (actualIndex < jsonData.length) {
                        final user = jsonData[actualIndex]['user'];
                        return DisplayContainerInsta(
                          user: user,
                          name: widget.username,
                          imgUrl: widget.imgUrl,
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentPage++;
                    });
                  },
                  child: const Text('Next Page'),
                )
              ]),
>>>>>>> Stashed changes
      ),
      body: jsonData.isEmpty
          ? const Center(
              child: SizedBox(
                  height: 125, width: 125, child: CircularProgressIndicator()))
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              //! length defined explicitly
              itemCount: 6,
              itemBuilder: (context, index) {
                final user = jsonData[index]['user'];
                return DisplayContainerInsta(
                  user: user,
                  name: widget.username,
                  imgUrl: widget.imgUrl,
                );
              },
            ),
    );
  }
}
