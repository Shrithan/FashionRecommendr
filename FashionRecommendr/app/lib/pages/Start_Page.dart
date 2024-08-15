import 'package:app/pages/Front_View_Capture.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Pages extends StatelessWidget {
  final CameraDescription camera;
  final String gender;
  final String age;
  final String height;
  Pages({
    Key? key,
    required this.camera,
    required this.age,
    required this.height,
    required this.gender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Page Navigation Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PageScreen(
        camera: camera,
        height: height,
        age: age,
        gender: gender,
      ),
    );
  }
}

class PageScreen extends StatefulWidget {
  final CameraDescription camera;
  final String gender;
  final String age;
  final String height;
  PageScreen({
    Key? key,
    required this.camera,
    required this.gender,
    required this.age,
    required this.height,
  }) : super(key: key);

  @override
  _PageScreenState createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6C1D1),
      appBar: AppBar(
        backgroundColor: Color(0xFF3A3A6A),
        iconTheme: IconThemeData(
          color: Color(0xFFF6C1D1), // Change this to your desired back button color
        ),
        title: Text(
          'Page Navigation',
          style: GoogleFonts.eduVicWaNtBeginner(
              textStyle: TextStyle(color: Color(0xFFF6C1D1))),
        ),
      ),
      body: Row(
        children: [
          // Left section with the page view
          Expanded(
            flex: 3,
            child: PageView(
              controller: _pageController,
              children: [
                _buildPage(
                  imageUrl: 'CV.png', // Sample Image URL
                  text: Text(
                    """
Lets use computer vision to find out your body measurements.
The ones that are neccessary 
                   """,
                    style: GoogleFonts.eduVicWaNtBeginner(
                        textStyle: TextStyle(
                            fontSize: 38, color: Color(0xFF3A3A6A))),
                  ),
                ),
                _buildPage(
                  imageUrl: 'CV2.png', 
                  text: Text(
                    """
We need to use your webcam to get an image of your front view and side view.
Lets do this   
                   """,
                    style: GoogleFonts.eduVicWaNtBeginner(
                        textStyle: TextStyle(
                            fontSize: 38, color: Color(0xFF3A3A6A))),
                  ),
                ),
                _buildPage(
                  imageUrl: 'FinalStartPage.png', 
                  text: Text(
                    """
See the images on the left. 
Make sure you are in the correct poses.
                   """,
                    style: GoogleFonts.eduVicWaNtBeginner(
                        textStyle: TextStyle(
                            fontSize: 38, color: Color(0xFF3A3A6A))),
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 150,
            decoration: BoxDecoration(
              color: Color(0xFFFFD166),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_pageController.page! > 0) {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('You are on the first page')),
                      );
                    }
                  },
                  child: Text('Back'),
                ),
                SizedBox(height: 20),
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 3, 
                  effect: WormEffect(
                    dotWidth: 12,
                    dotHeight: 12,
                    spacing: 16,
                    radius: 4,
                    dotColor: Color(0xFF3A3A6A),
                    activeDotColor: Color(0xFFF6C1D1),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_pageController.page! < 2) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CameraScreen(
                            camera: widget.camera,
                            height: widget.height,
                            age: widget.age,
                            gender: widget.gender,
                          ),
                        ),
                      );
                    }
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage({required String imageUrl, required Text text}) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          width: 1000,
          child: Image.asset(
            imageUrl,
            fit: BoxFit.cover,
            width: 400,
          ),
        ),
        Expanded(
          child: Container(
            color: Color(0xFFFFD166),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: text,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
