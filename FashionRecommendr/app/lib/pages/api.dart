import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:typed_data'; // For Uint8List

Future<Map<String, dynamic>> fetchData() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:5001/process/images'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}

Future<void> sendHeightAndAdditionalData({
  required double height,
  required int age,
  required String gender,
}) async {
  final url = Uri.parse('http://127.0.0.1:5001/process_images'); // Update with your server IP and port

  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'height': height,
      'age': age,
      'gender': gender,
    }),
  );

  if (response.statusCode == 200) {
    print('Data sent successfully.');
    // Process the response if necessary
  } else {
    print('Failed to send data. Status code: ${response.statusCode}');
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

Future<void> _finalizeProcessing(double h1, double h2, double s2, double height, int age, String gender) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:5001/finalize_processing'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'hip_distance1': h1,
      'hip_distance2': h2,
      'shoulder_distance2': s2,
      'height': height,
      'age': age,
      'gender': gender,
    }),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    print('Finalize Processing Response: ${data['message']}');
  } else {
    print('Failed to finalize processing');
  }
}

Future<Map<String, dynamic>> _processImage(String filename, double height) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:5001/process_images'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'filename': filename,
      'height': height,
    }),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    // Extract the needed values from the response
    final shoulderDistance = data['shoulder_distance'];
    final hipDistance = data['hip_distance'];

    // Return these values for use in the final processing
    return {
      'shoulder_distance': shoulderDistance,
      'hip_distance': hipDistance,
    };
  } else {
    throw Exception('Failed to process image');
  }
}



Future<Map<String, dynamic>> fetchProcessedImages() async {
  final url = 'http://127.0.0.1:5001/process_images'; // Replace with your Flask server URL

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // If the server returns an OK response, parse the JSON
    return jsonDecode(response.body);
  } else {
    // If the server did not return a 200 OK response, throw an error
    throw Exception('Failed to fetch processed images: ${response.reasonPhrase}');
  }
}


Future<Map<String, dynamic>> processImagesx(double height) async {
  final url = 'http://127.0.0.1:5001/process_images'; // Replace with your Flask server URL

  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'height': height}),
  );

  if (response.statusCode == 200) {
    // If the server returns an OK response, parse the JSON
    return jsonDecode(response.body);
  } else {
    // If the server did not return a 200 OK response, throw an error
    throw Exception('Failed to process images: ${response.reasonPhrase}');
  }
}

Future<void> submitData({
  required  s1,
  required  s2,
  required  h1,
  required  h2,
  required  height,
  required  gender,
  required  age,
}) async {
  final url = 'http://127.0.0.1:5001/submit_data'; // Replace with your server URL

  // Create the JSON payload
  final payload = {
    's1': s1,
    's2': s2,
    'h1': h1,
    'h2': h2,
    'height': height,
    'gender': gender,
    'age': age,
  };

  try {
    // Send the POST request
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    // Check the response status
    if (response.statusCode == 200) {
      print('Data submitted successfully');
    } else {
      print('Failed to submit data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error submitting data: $e');
  }
}