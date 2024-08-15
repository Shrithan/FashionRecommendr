import 'package:app/pages/Need.dart';
import 'package:app/pages/api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/elements.dart';

class Analysis extends StatefulWidget {
  final String height;
  final String age;
  final String gender;

  const Analysis({
    super.key,
    required this.height,
    required this.age,
    required this.gender,
  });

  @override
  _AnalysisState createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  bool isLoading = false;
  Map<String, dynamic>? results;

  void processImages() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await processImagesx(double.parse(widget.height));
      setState(() {
        results = response;
      });
    } catch (e) {
      print('Error sending stuff: $e');
      // Handle error if needed
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6C1D1), // Pink background color
      body: Stack(
        children: [
          // Yellow Circles at the edges with increased size and opacity
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
          
          // Main content area with text and buttons aligned to the center on the pink part
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Analyze your clothing size',
                  style: GoogleFonts.eduVicWaNtBeginner(
                    textStyle: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3A3A6A),  // Blue text color
                      textBaseline: TextBaseline.alphabetic,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: processImages,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFD166), // Yellow button color
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: isLoading
                      ? Container(
                          width: 200, // Width of the progress bar
                          height: 6, // Height of the progress bar
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.grey[300],
                            color: Colors.blue,
                          ),
                        )
                      : Text(
                          'Process Images',
                          style: GoogleFonts.eduVicWaNtBeginner(
                            textStyle: TextStyle(
                              fontSize: 24, 
                              color: Color(0xFF3A3A6A), // Blue text color for button
                            ),
                          ),
                        ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (results != null) {
                      final s1 = results!['s1'];
                      final s2 = results!['s2'];
                      final h1 = results!['h1'];
                      final h2 = results!['h2'];

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Need(
                            s1: s1,
                            s2: s2,
                            h1: h1,
                            h2: h2,
                            height: widget.height,
                            age: widget.age,
                            gender: widget.gender,
                          ),
                        ),
                      );
                    } else {
                      // Handle the case when results are not yet available
                      print('Results are not yet available');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFD166), // Yellow button color
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Text(
                    'View Data',
                    style: GoogleFonts.eduVicWaNtBeginner(
                      textStyle: TextStyle(
                        fontSize: 24, 
                        color: Color(0xFF3A3A6A), // Blue text color for button
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
