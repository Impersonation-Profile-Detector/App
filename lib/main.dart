import 'package:flutter/material.dart';
import 'package:impersonation_detector/Screens/homepage.dart';
import 'package:impersonation_detector/Theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme1,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
