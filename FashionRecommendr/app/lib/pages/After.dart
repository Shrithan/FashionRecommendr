import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class After extends StatefulWidget {
  final String imagePath;
  final String imagePath2;

  const After({super.key, required this.imagePath, required this.imagePath2});

  @override
  _AfterState createState() => _AfterState();
}

class _AfterState extends State<After> {
  File? _originalImage;
  File? _processedImage;
  bool _isProcessing = false;

  Future<File> _downloadImage(String url, String fileName) async {
    final response = await http.get(Uri.parse(url));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File('${documentDirectory.path}/$fileName');
    file.writeAsBytesSync(response.bodyBytes);
    return file;
  }

  Future<File> _sendImageToServer(File imageFile) async {
    final uri = Uri.parse('https://localhost:5000/process-image');  // Replace with your backend server URL
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final processedImageBytes = await response.stream.toBytes();
      final documentDirectory = await getApplicationDocumentsDirectory();
      final processedFile = File('${documentDirectory.path}/processed_image.png');
      processedFile.writeAsBytesSync(processedImageBytes);
      return processedFile;
    } else {
      throw Exception('Failed to upload image');
    }
  }

  Future<void> _processImages() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Download and process the first image
      _originalImage = await _downloadImage(widget.imagePath, 'original_image.png');
      _processedImage = await _sendImageToServer(_originalImage!);

      // Optionally, do the same for the second image (widget.imagePath2)

      setState(() {
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isProcessing
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_originalImage != null)
                        Image.file(_originalImage!),
                      if (_processedImage != null)
                        Image.file(_processedImage!),
                    ],
                  ),
                  SizedBox(height: 20),
                  FloatingActionButton(
                    onPressed: _processImages,
                    child: Icon(Icons.run_circle),
                  ),
                ],
              ),
      ),
    );
  }
}
