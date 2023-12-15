import 'package:flutter/material.dart';
import 'package:impersonation_detector/Screens/instagram.dart';
import 'package:impersonation_detector/Screens/twitter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.5,
              child: ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.red),
                  elevation: MaterialStatePropertyAll(0),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => const InstaHome()),
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
