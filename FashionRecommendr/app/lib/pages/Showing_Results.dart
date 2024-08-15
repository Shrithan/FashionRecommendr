import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app/elements.dart';  // Assuming elements.dart has the custom widgets like YellowCircle, DottedShape, and StraightLinesPainter.

Future<List<Map<String, String>>> loadProductData() async {
  final imageData = await rootBundle.loadString('~FashionRecommendr/app/assets/image_urls.txt');
  final linkData = await rootBundle.loadString('~FashionRecommendr/app/assets/links.txt');
  
  final imageUrls = imageData.split('\n').where((line) => line.isNotEmpty).toList();
  final productUrls = linkData.split('\n').where((line) => line.isNotEmpty).toList();

  if (imageUrls.length != productUrls.length) {
    throw Exception('Mismatch between number of images and links.');
  }

  final List<Map<String, String>> products = List.generate(imageUrls.length, (index) {
    return {
      'imageUrl': imageUrls[index].trim(),
      'productUrl': productUrls[index].trim(),
    };
  });

  return products;
}

class EcommercePage extends StatefulWidget {
  @override
  _EcommercePageState createState() => _EcommercePageState();
}

class _EcommercePageState extends State<EcommercePage> {
  Future<List<Map<String, String>>>? _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = loadProductData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6C1D1),  // Pink background color to match
      appBar: AppBar(backgroundColor: Color(0xFF3A3A6A) ,title: Text("Results", style: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle(color: Color(0xFFF6C1D1))),),iconTheme: IconThemeData(
          color: Color(0xFFF6C1D1), // Change this to your desired back button color
        )),
      body: Stack(
        children: [
          // Background elements (Yellow Circles, Dotted Shapes, etc.)
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
            left: -200,
            top: -60,
            child: YellowCircle(size: 700, opacity: 0.3),
          ),
          
          // Main content area with GridView
          FutureBuilder<List<Map<String, String>>>(
            future: _futureProducts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.teal,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.red, fontSize: 16.0),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'No products found',
                    style: TextStyle(color: Colors.black54, fontSize: 18.0),
                  ),
                );
              } else {
                final products = snapshot.data!;
                return GridView.builder(
                  padding: EdgeInsets.all(16.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final imageUrl = product['imageUrl']!;
                    final productUrl = product['productUrl']!;
                    return GestureDetector(
                      onTap: () {
                        _launchURL(productUrl);
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        elevation: 8.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                                color: Colors.teal,
                              ),
                            ),
                            errorWidget: (context, url, error) => Center(
                              child: Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
          
          // "Get started" button in the same style
          Positioned(
            left: 0,
            right: 0,
            bottom: 50,
            child: Center(
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
