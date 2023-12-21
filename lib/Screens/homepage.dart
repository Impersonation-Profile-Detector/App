import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impersonation_detector/screens/insta_results.dart';
import 'package:impersonation_detector/screens/x_results.dart';
import 'package:avatar_glow/avatar_glow.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isInsta = false;
  bool isX = false;
  String _name = "";
  File? _selectedImage;
  String imgUrl = "";

  final _controller = TextEditingController();
  bool validate = false;

  void submitInstaDetails() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
            child: CircularProgressIndicator(
          color: Colors.white,
        ));
      },
    );
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('$_name.jpg');
      await storageRef.putFile(_selectedImage!);
      imgUrl = await storageRef.getDownloadURL();
      if (!mounted) return;
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              InstaResultsPage(username: _name, imgUrl: imgUrl),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  void submitXDetails() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
            child: CircularProgressIndicator(
          color: Colors.white,
        ));
      },
    );
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('$_name.jpg');
      await storageRef.putFile(_selectedImage!);
      imgUrl = await storageRef.getDownloadURL();
      if (!mounted) return;
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => XResultsPage(username: _name, imgUrl: imgUrl),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 90,
                  ),
                  GestureDetector(
                    onTap: () {
                      _getFromCamera();
                    },
                    child: Center(
                      child: SizedBox(
                        height: 170,
                        width: 170,
                        child: AvatarGlow(
                          startDelay: const Duration(milliseconds: 1000),
                          glowColor: Colors.white,
                          glowShape: BoxShape.circle,
                          animate: true,
                          glowCount: 1,
                          glowRadiusFactor: 0.3,
                          curve: Curves.fastOutSlowIn,
                          child: Material(
                            elevation: 8.0,
                            shape: const CircleBorder(),
                            color: Colors.transparent,
                            child: CircleAvatar(
                              backgroundImage: (_selectedImage == null)
                                  ? const AssetImage('assets/user.png')
                                  : FileImage(_selectedImage!) as ImageProvider,
                              radius: 50.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  const Text(
                    'Name',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 290,
                    height: 45,
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        fillColor: const Color(0xffd9d9d9),
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Enter your name here',
                        alignLabelWithHint: true,
                        hintStyle: const TextStyle(
                            color: Color.fromARGB(202, 0, 0, 0)),
                        errorText:
                            validate ? "Name field Can't Be Empty" : null,
                      ),
                      onChanged: (value) {
                        _name = value;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Select the SNS',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isInsta = !isInsta;
                            isX = false;
                          });
                        },
                        child: isInsta
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Tab(
                                    icon: Image.asset("assets/insta_dark.png"),
                                    height: 120,
                                  ),
                                  const Text(
                                    'Instagram',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            : Column(
                                children: [
                                  Tab(
                                    icon: Image.asset("assets/insta.png"),
                                    height: 120,
                                  ),
                                  const Text(
                                    'Instagram',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isX = !isX;
                            isInsta = false;
                          });
                        },
                        child: isX
                            ? Column(
                                children: [
                                  Tab(
                                    icon:
                                        Image.asset("assets/twitter_dark.png"),
                                    height: 120,
                                  ),
                                  const Text(
                                    'Twitter X',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            : Column(
                                children: [
                                  Tab(
                                    icon: Image.asset("assets/twitter.png"),
                                    height: 120,
                                  ),
                                  const Text(
                                    'Twitter X',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 40,
                    width: 290,
                    child: ElevatedButton(
                      style: const ButtonStyle(
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        shadowColor: MaterialStatePropertyAll(
                          Color.fromARGB(81, 0, 0, 0),
                        ),
                        backgroundColor: MaterialStatePropertyAll(
                          Color(0xffd9d9d9),
                        ),
                      ),
                      onPressed: () {
                        if (isInsta) {
                          submitInstaDetails();
                        } else if (isX) {
                          submitXDetails();
                        }
                      },
                      child: const Text(
                        'Find Profiles',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1e1e1e)),
                      ),
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }

  Future _getFromCamera() async {
    final returnedImage = await ImagePicker().pickImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
    if (returnedImage == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('We are facing some issue.Try again later'),
        ),
      );
      return;
    }
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }
}
