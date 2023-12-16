import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:impersonation_detector/Screens/homepage.dart';
import 'package:impersonation_detector/Theme/theme.dart';
import 'firebase_options.dart';
import 'package:impersonation_detector/Screens/insta_results.dart';

void main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme1,
      debugShowCheckedModeBanner: false,
      home: const InstaResultsPage(username: 'elon',),
    );
  }
}
