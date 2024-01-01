import 'dart:io';
import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';

class Camera extends StatefulWidget {
  const Camera({super.key, required this.onPickedImage});
  final void Function(File pickedImage) onPickedImage;

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CameraCamera(
        cameraSide: CameraSide.all,
        onFile: (file) {
          widget.onPickedImage(file);
          Navigator.pop(context);
        },
      ),
    );
  }
}
