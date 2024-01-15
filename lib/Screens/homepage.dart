import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:impersonation_detector/Screens/Facebook/facebook_results.dart';
import 'package:impersonation_detector/Services/camera.dart';
import 'package:impersonation_detector/screens/Insta/insta_results.dart';
import 'package:impersonation_detector/screens/X/x_results.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:images_picker/images_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

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
  String compressedImagePath = "/storage/emulated/0/Download/";

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

  Future<bool> storagePermission() async {
    final DeviceInfoPlugin info = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await info.androidInfo;
    final int androidVersion = int.parse(androidInfo.version.release);
    bool havePermission = false;

    if (androidVersion >= 13) {
      final request = await [
        Permission.videos,
        Permission.photos,
      ].request();

      havePermission =
          request.values.every((status) => status == PermissionStatus.granted);
    } else {
      final status = await Permission.storage.request();
      havePermission = status.isGranted;
    }

    if (!havePermission) {
      await openAppSettings();
    }

    return havePermission;
  }

  @override
  void initState() {
    super.initState();
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
                    height: 70,
                  ),
                  const Text(
                    'Upload Image',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () async {
                      final permission = await storagePermission();
                      if (!mounted) return;
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Upload Image'),
                              content: const SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text(
                                        'From where would you like to upload image ?'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Gallery'),
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    final DeviceInfoPlugin info =
                                        DeviceInfoPlugin();
                                    final AndroidDeviceInfo androidInfo =
                                        await info.androidInfo;
                                    final int androidVersion =
                                        int.parse(androidInfo.version.release);
                                    if (androidVersion >= 13) {
                                      _getFromCamera();
                                    } else {
                                      getImageGallery();
                                    }
                                  },
                                ),
                                TextButton(
                                  child: const Text('Camera'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    getImageCamera();
                                  },
                                ),
                              ],
                            );
                          });
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
                          glowRadiusFactor: 0.2,
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
                    height: 20,
                  ),
                  const Text(
                    'Name',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 16,
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
                    height: 20,
                  ),
                  const Text(
                    'Select the SNS',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          setState(() {
                            isInsta = !isInsta;
                            isX = false;
                          });
                        },
                        child: Container(
                          height: 150,
                          width: 100,
                          decoration: isInsta
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                )
                              : const BoxDecoration(),
                          child: Column(
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
                      ),
                      GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          setState(() {
                            isX = !isX;
                            isInsta = false;
                          });
                        },
                        child: Container(
                          height: 150,
                          width: 100,
                          decoration: isX
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                )
                              : const BoxDecoration(),
                          child: Column(
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
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     FocusManager.instance.primaryFocus?.unfocus();
                      //     Navigator.of(context).pushReplacement(
                      //       MaterialPageRoute(
                      //         builder: (context) => FacebookScraper(),
                      //       ),
                      //     );
                      //   },
                      //   child: Container(
                      //     height: 150,
                      //     width: 50,
                      //     decoration: isX
                      //         ? BoxDecoration(
                      //             borderRadius: BorderRadius.circular(15),
                      //             border:
                      //                 Border.all(color: Colors.white, width: 2),
                      //           )
                      //         : const BoxDecoration(),
                      //     child: Column(
                      //       children: [
                      //         Tab(
                      //           icon: Image.asset(
                      //             "assets/Spy.png",
                      //             color: Colors.black,
                      //           ),
                      //           height: 120,
                      //         ),
                      //         const Text(
                      //           'Meta',
                      //           style: TextStyle(
                      //               color: Colors.white,
                      //               fontWeight: FontWeight.bold),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    height: 40,
                    width: 290,
                    child: Hero(
                      tag: 'home-button',
                      child: ElevatedButton(
                        style: const ButtonStyle(
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                          backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 237, 236, 236),
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
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }

  Future getImageGallery() async {
    List<Media>? res = await ImagesPicker.pick(
      count: 1,
      pickType: PickType.image,
    );
    setState(() {
      _selectedImage = File(res!.first.path);
    });
  }

  Future getImageCamera() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Camera(
          onPickedImage: (File pickedImage) {
            if (mounted) {
              setState(() {
                _selectedImage = File(pickedImage.path);
              });
            }
          },
        ),
      ),
    );
  }

  Future compressImage() async {
    if (_selectedImage == null) return null;
    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      _selectedImage!.path,
      "$compressedImagePath/file.jpg",
    );
    if (compressedFile != null) {
      _selectedImage = File(compressedFile.path);
    }
    compressImage();
  }

  Future _getFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
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
