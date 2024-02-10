import 'package:flutter/material.dart';
import 'package:impersonation_detector/Screens/homepage.dart';
import 'package:impersonation_detector/Widgets/disclaimer.dart';

class OnboardSreen extends StatelessWidget {
  const OnboardSreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/waves1.png'), fit: BoxFit.cover),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(
                  height: 60,
                ),
                const Text(
                  'NER Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                  ),
                ),
                const SizedBox(
                  height: 55,
                ),
                Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.white60,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(4, 4),
                          blurRadius: 4,
                          color: Color.fromARGB(255, 37, 37, 37),
                        )
                      ],
                      border: Border.all(color: Colors.white, width: 0.3)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/social.png',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  'A mobile app to check whether there are accounts impersonating a given social media account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 50,
                  width: 200,
                  child: Hero(
                    tag: 'home-button',
                    child: ElevatedButton(
                      onPressed: () async {
                        await showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return const Disclaimer();
                          },
                        );
                      },
                      child: const Text(
                        'Detect',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
