import 'package:flutter/material.dart';
import 'package:impersonation_detector/Screens/homepage.dart';

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
                  'Im-persona',
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
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/social.png',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                const Text(
                  'Im-persona is your trusty companion in online authenticity. The app employs advanced machine learning algorithms to seamlessly detect and weed out fake profiles across various social networks.',
                  style: TextStyle(fontSize: 16, color: Colors.white),
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 400),
                            pageBuilder: (_, __, ___) => const HomePage(),
                          ),
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
