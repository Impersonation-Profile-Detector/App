// ignore_for_file: unused_import

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:impersonation_detector/Screens/insta_results.dart';
import 'package:impersonation_detector/Theme/theme.dart';

class InstaHome extends StatefulWidget {
  const InstaHome({super.key});

  @override
  State<InstaHome> createState() => _InstaHomeState();
}

class _InstaHomeState extends State<InstaHome> {
  String _name = "";
  File? _selectedImage;

  final _controller = TextEditingController();
  bool _validate = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            const Text(
              'Enter Your Name',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Enter the Value',
                  errorText: _validate ? "Value Can't Be Empty" : null,
                ),
                onChanged: (value) {
                  _name = value;
                },
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Upload Your Image',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            GestureDetector(
              onTap: () {
                _getFromCamera();
              },
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    width: 1.5,
                  ),
                ),
                height: 250,
                width: 300,
                alignment: Alignment.center,
                child: _selectedImage != null
                    ? Image.file(_selectedImage!, fit: BoxFit.cover)
                    : const Text(
                        "Tap here to upload an image",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            Center(
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.7,
                child: ElevatedButton(
                  style: const ButtonStyle(
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              12,
                            ),
                          ),
                        ),
                      ),
                      elevation: MaterialStatePropertyAll(0),
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 91, 200, 251))),
                  onPressed: () {
                    setState(() {
                      _validate = _controller.text.isEmpty;
                    });
                    if(!_validate){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              InstaResultsPage(username: _name),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Proceed',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _getFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
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
