import 'package:flutter/material.dart';
import 'package:impersonation_detector/Screens/insta_results.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Impersonation Profile Detector',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            const SizedBox(
              height: 100,
            ),
            const Text(
              'Select the social media platform',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 25,
            ),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Enter username'),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.5,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                  elevation: MaterialStateProperty.all(0),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InstaResultsPage(username: usernameController.text),
                    ),
                  );
                },
                child: const Text(
                  'Instagram',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
