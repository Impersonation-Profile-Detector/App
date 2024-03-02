import 'package:flutter/material.dart';
import 'package:impersonation_detector/Screens/homepage.dart';

class Disclaimer extends StatelessWidget {
  const Disclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey[800]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.70,
              child: const Divider(
                color: Colors.white,
                height: 2,
                thickness: 0.5,
              )),
          const SizedBox(
            height: 8,
          ),
          const Text(
            'Disclaimer',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          const Text(
            'NER Profile is a tool designed to aid in identifying potential fake profiles on social media platforms. While we strive for accuracy, results may vary. Users are encouraged to use their discretion and verify findings independently. The end user should independently verify the results before making any decisions or taking actions based on the results provided.',
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          const SizedBox(
            height: 24,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            height: 50,
            child: OutlinedButton(
                style: const ButtonStyle(
                  side: MaterialStatePropertyAll(
                    BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 400),
                      pageBuilder: (_, __, ___) => const HomePage(),
                    ),
                  );
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                )),
          ),
          const SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }
}
