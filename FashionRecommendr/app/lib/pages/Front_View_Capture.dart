import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data'; // For Uint8List
import 'package:app/pages/Side_View_Capture.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;
  final String height;
  final String age;
  final String gender;

  CameraScreen({required this.camera, required this.height, required this.age, required this.gender});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late CameraDescription camera2;
  final html.FileUploadInputElement _picker = html.FileUploadInputElement();
  Uint8List? _selectedFileBytes;
  bool _isCameraImage = false;
  bool _isCapturing = false;
  int _timerCountdown = 7;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();

    availableCameras().then((cameras) {
      if (cameras.length > 1) {
        setState(() {
          camera2 = cameras[1];
        });
      } else {
        setState(() {
          camera2 = widget.camera;
        });
      }
    }).catchError((e) {
      print("Error fetching cameras: $e");
    });

    _picker.accept = 'image/*';
    _picker.onChange.listen((e) {
      final files = _picker.files;
      if (files!.isEmpty) return;
      final reader = html.FileReader();
      reader.readAsArrayBuffer(files[0]);
      reader.onLoadEnd.listen((e) {
        setState(() {
          _selectedFileBytes = reader.result as Uint8List;
        });
      });
    });
  }

  void _openFilePicker() {
    _picker.click();
  }

  void _startTimer() {
    setState(() {
      _isCapturing = true;
      _timerCountdown = 7;
    });

    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _timerCountdown--;
      });

      if (_timerCountdown == 0) {
        timer.cancel();
        _captureImage();
      }
    });
  }

  Future<void> _captureImage() async {
  try {
    final image = await _controller.takePicture();
    final imageBytes = await image.readAsBytes(); // Read image as bytes

    setState(() {
      _isCameraImage = true;
      _isCapturing = false;
    });

    // Navigate to FrontViewContinuation without uploading the image
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FrontViewContinuation2(
          camera: camera2,
          imagePath: image.path,
          isCameraImage: _isCameraImage,
          imageBytes1: imageBytes,
          height: widget.height,
          age: widget.age,
          gender: widget.gender,
        ),
      ),
    );
  } catch (e) {
    print('Error capturing image: $e');
  }
}


  Future<void> _uploadImage(Uint8List imageBytes, String fileName) async {
  try {
    var uri = Uri.parse('http://127.0.0.1:5001/upload');
    var request = http.MultipartRequest('POST', uri)
      ..files.add(http.MultipartFile.fromBytes('file', imageBytes, filename: fileName));

    var response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      print('Upload successful: $responseData');
    } else {
      print('Upload failed.');
    }
  } catch (e) {
    print('Error uploading image: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6C1D1),
      appBar: AppBar(
        backgroundColor: Color(0xFF3A3A6A),
        iconTheme: IconThemeData(color: Color(0xFFF6C1D1)),
        title: Text('Front-View Camera Preview', style: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle(color: Color(0xFFF6C1D1))),),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Color(0xFFFFD166)),
              height: 900,
              width: 500,
              child: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        CameraPreview(_controller),
                        if (_isCapturing)
                          Center(
                            child: Text(
                              '$_timerCountdown',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
          const SizedBox(
            width: 100,
          ),
          Column(
            children: [
              ElevatedButton(
                onPressed: _isCapturing
                    ? null
                    : () {
                        _startTimer();
                      },
                child: const Icon(Icons.camera),
              ),
              const Text("Capture"),
              const SizedBox(
                height: 100,
              ),
              ElevatedButton(
                onPressed: _openFilePicker,
                child: Text("Choose File"),
              ),
              _selectedFileBytes != null
                  ? Text('Selected file: ${_selectedFileBytes!.length} bytes')
                  : Container(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_selectedFileBytes != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FrontViewContinuation2(
                          camera: camera2,
                          imagePath: '',
                          isCameraImage: false,
                          imageBytes1: _selectedFileBytes!,
                          height: widget.height,
                          age: widget.age,
                          gender: widget.gender,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("No file selected")),
                    );
                  }
                },
                child: Text("Process Selected File"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class FrontViewContinuation2 extends StatelessWidget {
  final CameraDescription camera;
  final String imagePath;
  final bool isCameraImage;
  final Uint8List? imageBytes1;
  final String height;
  final String age;
  final String gender;

  const FrontViewContinuation2({
    Key? key,
    required this.camera,
    required this.imagePath,
    required this.isCameraImage,
    required this.age,
    required this.height,
    required this.gender,
    this.imageBytes1,
  }) : super(key: key);

  Future<void> _uploadImage(Uint8List imageBytes1, String fileName) async {
    try {
      var uri = Uri.parse('http://127.0.0.1:5001/upload');
      var request = http.MultipartRequest('POST', uri)
        ..files.add(http.MultipartFile.fromBytes('file', imageBytes1, filename: fileName));

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        print('Upload successful: $responseData');
      } else {
        print('Upload failed.');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6C1D1),
      appBar: AppBar(
        backgroundColor: Color(0xFF3A3A6A),
        iconTheme: IconThemeData(color: Color(0xFFF6C1D1)),
        title: Text('Confirm Front Image', style: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle(color: Color(0xFFF6C1D1))),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Color(0xFFFFD166)),
                height: 500,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: isCameraImage
                      ? Image.network((imagePath)) // Displaying local image file
                      : imageBytes1 != null
                          ? Image.memory(imageBytes1!) // Displaying image from bytes
                          : Container(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (imageBytes1 != null) {
                  // Upload image only when the button is pressed
                  _uploadImage(imageBytes1!, 'selected_image.jpg');
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CameraScreen2(camera: camera, img1: imageBytes1, height: height, age: age, gender: gender,),
                    ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("No image to upload")),
                  );
                }
              },
              child: Text("Confirm"),
            ),
          ],
        ),
      ),
    );
  }
}