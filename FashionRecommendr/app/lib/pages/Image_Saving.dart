
import 'package:app/pages/Side_View_Capture.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data'; // For Uint8List


var image_path_1 = "";
var image_path_2 = "";

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Hello")
    );
  }
}

class FVC extends StatelessWidget {
  final CameraDescription camera;
  final bool CameraImage;
  final String imagePath;

  FVC({required this.camera, required this.imagePath, required this.CameraImage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Main Page",
      home: FrontViewContinuation(camera: camera, imagePath: imagePath, isCameraImage: CameraImage,),
    );
  }
}

class FrontViewContinuation extends StatelessWidget {
  final CameraDescription camera;
  final String imagePath;
  final bool isCameraImage;
  final Uint8List? imageBytes1; // Add this to handle image bytes

  

  const FrontViewContinuation({
    Key? key,
    required this.camera,
    required this.imagePath,
    required this.isCameraImage,
    this.imageBytes1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Front-view Picture')),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 500,
              child: isCameraImage
                  ? Image.network(imagePath) // For local file paths, use File (for non-web platforms)
                  : imageBytes1 != null
                      ? Image.memory(imageBytes1!) // For image bytes
                      : Container(),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CameraScreen2(camera: camera, img1: imageBytes1, height: "0", age:("0"), gender: "",),
                  ),
                );
              },
              child: Text("Confirm"),
            ),
          ],
        ),
      ),
    );
  }
}

class SideViewContinuation extends StatelessWidget {
  final CameraDescription camera;
  final String imagePath;
  final bool isCameraImage;
  final Uint8List? imageBytes2; // Add this to handle image bytes

  const SideViewContinuation({
    Key? key,
    required this.camera,
    required this.imagePath,
    required this.isCameraImage,
    this.imageBytes2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Side-view Picture')),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 500,
              child: isCameraImage
                  ? Image.network(imagePath) // For local file paths, use File (for non-web platforms)
                  : imageBytes2 != null
                      ? Image.memory(imageBytes2!) // For image bytes
                      : Container(),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => After2(),
                  ),
                );
              },
              child: Text("Confirm"),
            ),
          ],
        ),
      ),
    );
  }
}

class DisplayPictureScreen2 extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen2({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Side-view Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Center(
          child: Column(
        children: [
          Container(height: 500, child: Image.network(imagePath)),
        ],
      )),
    );
  }
}

class After2 extends StatelessWidget {
  const After2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("data") 
    );
  }
}