import 'package:app/pages/API.dart';
import 'package:app/pages/Showing_Results.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/elements.dart';

class Need extends StatefulWidget {
  final s1;
  final s2;
  final h1;
  final h2;
  final height;
  final age;
  final gender;

  const Need({
    super.key,
    required this.h1,
    required this.h2,
    required this.s1,
    required this.s2,
    required this.age,
    required this.gender,
    required this.height,
  });

  @override
  _NeedState createState() => _NeedState();
}

class _NeedState extends State<Need> {
  bool _isLoading = false;
  bool _showSeeResultsButton = false;

  void _getResults() async {
    setState(() {
      _isLoading = true;
      _showSeeResultsButton = false;
    });

    // Simulate a delay for the process (replace this with your actual process)
    await submitData(
      s1: widget.s1,
      s2: widget.s2,
      h1: widget.h1,
      h2: widget.h2,
      height: widget.height,
      gender: widget.gender,
      age: widget.age,
    );

    setState(() {
      _isLoading = false;
      _showSeeResultsButton = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6C1D1), // Pink background color
      body: Stack(
        children: [
          // Background yellow circles
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

          // Dotted shapes
          Positioned(
            left: 30,
            top: 100,
            child: DottedShape(
              size: 150,
              spacing: 20,
              shape: ShapeType.triangle,
            ),
          ),
          Positioned(
            left: 400,
            top: 500,
            child: DottedShape(
              size: 150,
              spacing: 40,
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

          // Straight lines
          Positioned(
            left: 50,
            top: 100,
            child: CustomPaint(
              painter: StraightLinesPainter(
                spacing: 40,
                bounds: Rect.fromLTWH(0, 0, 300, 400),
                offset: Offset(-100, 500),
              ),
              size: Size(300, 400),
            ),
          ),

          // Main content
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 1000,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Analyze Your Size',
                    style: GoogleFonts.eduVicWaNtBeginner(
                      textStyle: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3A3A6A),  // Blue text color
                        textBaseline: TextBaseline.alphabetic,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'This might take a few minutes. Pleas stay patient',
                    style: GoogleFonts.eduVicWaNtBeginner(
                      textStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3A3A6A),  // Blue text color
                        textBaseline: TextBaseline.alphabetic,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _getResults,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFD166), // Yellow button color
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text(
                      'Get Results',
                      style: GoogleFonts.eduVicWaNtBeginner(
                        textStyle: TextStyle(
                          fontSize: 32, 
                          color: Color(0xFF3A3A6A), // Blue text color for button
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  if (_isLoading) CircularProgressIndicator(),  // Show loading indicator

                  if (_showSeeResultsButton) 
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EcommercePage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFD166), // Yellow button color
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      child: Text(
                        'See Results',
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
    );
  }
}
