// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:app/pages/api.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http; // For HTTP requests

// class QueryPage extends StatefulWidget {
//   final String imgpath1;
//   final String imgpath2;

//   QueryPage({super.key, required this.imgpath1, required this.imgpath2});

//   @override
//   _QueryPageState createState() => _QueryPageState(imgpath1: imgpath1, imgpath2: imgpath2);
// }

// class _QueryPageState extends State<QueryPage> {
//   final String imgpath1;
//   final String imgpath2;

//   _QueryPageState({required this.imgpath1, required this.imgpath2});

//   bool isLoading = false;
//   String? errorMessage;
//   Map<String, dynamic>? responseData1;
//   Map<String, dynamic>? responseData2;

//   @override
//   void initState() {
//     super.initState();
//     fetchData(imgpath1, isFirstImage: true);
//     fetchData(imgpath2, isFirstImage: false);
//   }

//   Future<void> fetchData(String imagePath, {required bool isFirstImage}) async {
//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//     });

    
//       final response = await http.get(Uri.parse(imagePath));
//         final imageData = response.bodyBytes;

//         // Send image data to your API
//         final apiUrl = 'http://127.0.0.1:5001/process_image';
//         final apiResponse = await processImage(imagePath);
//         print(apiResponse);


//         setState(() {
//           if (isFirstImage) {
//             responseData1 = responseData1;
//           } else {
//             responseData2 = responseData2;
//           }
//           isLoading = false;
//         });

//         // Print results for each image
//         // if (isFirstImage) {
//         //   print('Results for the first image:');
//         //   print('Hip distance: ${apiResponse['final_hip']} cm');
//         //   print('Shoulder distance: ${data['final_shoulder']} cm');
//         // } else {
//         //   print('Results for the second image:');
//         //   print('Hip distance: ${data['final_hip']} cm');
//         //   print('Shoulder distance: ${data['final_shoulder']} cm');
//         // }
//     } 

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('PYTHON AND FLUTTER'),
//       ),
//       body: Center(
//         child: isLoading
//             ? CircularProgressIndicator()
//             : errorMessage != null
//                 ? Text(
//                     errorMessage!,
//                     style: TextStyle(fontSize: 18.0, color: Colors.red),
//                   )
//                 : Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       if (responseData1 != null) ...[
//                         Text(
//                           'First Image - Hip distance: ${responseData1!['final_hip']} cm',
//                           style: TextStyle(fontSize: 20.0),
//                         ),
//                         Text(
//                           'First Image - Shoulder distance: ${responseData1!['final_shoulder']} cm',
//                           style: TextStyle(fontSize: 20.0),
//                         ),
//                       ],
//                       if (responseData2 != null) ...[
//                         Text(
//                           'Second Image - Hip distance: ${responseData2!['final_hip']} cm',
//                           style: TextStyle(fontSize: 20.0),
//                         ),
//                         Text(
//                           'Second Image - Shoulder distance: ${responseData2!['final_shoulder']} cm',
//                           style: TextStyle(fontSize: 20.0),
//                         ),
//                       ],
//                       ElevatedButton(onPressed: () {
//                         // Add your button logic here
//                       }, child: Text("Continue"))
//                     ],
//                   ),
//       ),
//     );
//   }
// }