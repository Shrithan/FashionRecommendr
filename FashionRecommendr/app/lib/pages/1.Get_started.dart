import 'package:app/elements.dart';
import 'package:app/pages/User_form.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;
  MyApp({Key? key, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GoalTrackingPage(camera: camera),
    );
  }
}

class GoalTrackingPage extends StatelessWidget {
  final CameraDescription camera;
  GoalTrackingPage({Key? key, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6C1D1), // Pink background color
      body: ClipRect(
        child: Stack(
          children: [
            // Yellow Circles at the edges
            Positioned(
              left: 100,
              top: -100,
              child: YellowCircle(size: 500, opacity: 0.7),
            ),
            Positioned(
              left: 100,
              bottom: -100,
              child: YellowCircle(size: 500, opacity: 0.4),
            ),
            Positioned(
              right: -50,
              bottom: -50,
              child: YellowCircle(size: 300, opacity: 0.6),
            ),
            Positioned(
              left: -300,
              bottom: -100,
              child: YellowCircle(size: 1000, opacity: 0.3),
            ),
            Positioned(
              left: -599,
              bottom: -1000,
              child: YellowCircle(size: 1500, opacity: 0.7),
            ),
            Positioned(
              left: -200,
              top: -60,
              child: YellowCircle(size: 700, opacity: 0.3),
            ),
            
            // Dotted Triangles
            Positioned(
              left: 30,
              top: 100,
              child: DottedShape(
                size: 150,
                spacing: 20, // Adjust spacing between the dots
                shape: ShapeType.triangle,
              ),
            ),
            Positioned(
              left: 400,
              top: 500,
              child: DottedShape(
                size: 150,
                spacing: 40, // Adjust spacing between the dots
                shape: ShapeType.square,
              ),
            ),
            Positioned(
              right: 80,
              bottom: 120,
              child: DottedShape(
                size: 180,
                spacing: 4,
                shape: ShapeType.triangle,
              ),
            ),
            
            // Straight lines within a specified area and position
            Positioned(
              left: 50,
              top: 100,
              child: CustomPaint(
                painter: StraightLinesPainter(
                  spacing: 40, // Spacing between lines
                  bounds: Rect.fromLTWH(0, 0, 300, 400), // Bounds for the grid
                  offset: Offset(-100, 500), // Offset for positioning the grid
                ),
                size: Size(300, 400), // Size of the canvas where lines are drawn
              ),
            ),
            
            // Main content area with text aligned to the center on the pink part
            Row(
              mainAxisAlignment: MainAxisAlignment.end,

              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 50),
                      child: Text(
                        'Find the right clothing for you',
                        style: GoogleFonts.eduVicWaNtBeginner(
                          textStyle: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3A3A6A),  // Blue text color
                            textBaseline: TextBaseline.alphabetic,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => UserInfoForm(camera: camera),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFD166), // Yellow button color
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      child: Text(
                        'Get started',
                        style: GoogleFonts.eduVicWaNtBeginner(
                          textStyle: TextStyle(
                            fontSize: 32, 
                            color: Color(0xFF3A3A6A), // Blue text color for button
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
