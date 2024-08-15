import 'package:app/pages/Need.dart';
import 'package:app/pages/Start_Page.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart'; // Adjust the import as needed

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
      title: 'User Info Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserInfoForm(camera: camera),
    );
  }
}

class UserInfoForm extends StatefulWidget {
  final CameraDescription camera;
  
  UserInfoForm({Key? key, required this.camera}) : super(key: key);
  @override
  _UserInfoFormState createState() => _UserInfoFormState();
}

class _UserInfoFormState extends State<UserInfoForm> {
  final _formKey = GlobalKey<FormState>();
  String? _gender;
  String? _heightUnit = 'cm';
  int? _age;
  double? _height;
  double? _hipWidth;
  double? _hipLength;
  double? _shoulderLength;

  // Function to convert inches to centimeters
  double _convertInchesToCm(double inches) {
    return inches * 2.54;
  }

  // Function to validate fields based on which button is pressed
  bool _validateFields({required bool requireAllFields}) {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      if (requireAllFields) {
        return _hipLength != null && _hipWidth != null && _shoulderLength != null;
      }
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6C1D1),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(0xFFF6C1D1), // Change this to your desired back button color
        ),
        backgroundColor: Color(0xFF3A3A6A),
        title: Text('Enter Your Information', style: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle(color: Color(0xFFF6C1D1))),),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('measurementsBoy.png'),
            SizedBox(width: 20,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("""
Yellow line - Shoulder Length
Blue line - Hip Length
Red line - Hip Width

Note: You don't NEED to know your measurements, just click on Find-Out
                 """, textAlign: TextAlign.center, style: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.w500 ,color: Color(0xFF3A3A6A)))),
                Center(
                  child: Container(
                    width: 600,
                    height: 550, // Adjust width as needed
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(0xFFFFD166)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Age Input
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    labelText: ("Age"),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your age';
                                    }
                                    final age = int.tryParse(value);
                                    if (age == null || age <= 0) {
                                      return 'Please enter a valid age';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _age = int.parse(value!);
                                  },
                                ),
                          
                                // Gender Input
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    labelText: 'Gender',
                                  ),
                                  value: _gender,
                                  items: ['Male', 'Female', 'Other'].map((String gender) {
                                    return DropdownMenuItem<String>(
                                      value: gender,
                                      child: Text(gender),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _gender = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select your gender';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _gender = value;
                                  },
                                ),
                          
                                // Height Unit Selector
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    labelText: 'Height Unit',
                                  ),
                                  value: _heightUnit,
                                  items: ['cm', 'inches'].map((String unit) {
                                    return DropdownMenuItem<String>(
                                      value: unit,
                                      child: Text(unit),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _heightUnit = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a height unit';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _heightUnit = value;
                                  },
                                ),
                          
                                // Height Input
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    helperStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    errorStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    prefixStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    suffixStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    counterStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    floatingLabelStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    labelStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    labelText: 'Height',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your height';
                                    }
                                    final height = double.tryParse(value);
                                    if (height == null || height <= 0) {
                                      return 'Please enter a valid height';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    double height = double.parse(value!);
                                    if (_heightUnit == 'inches') {
                                      height = _convertInchesToCm(height);
                                    }
                                    _height = height;
                                  },
                                ),
                          
                                // Hip Circumference Input (Optional)
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    helperStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    errorStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    prefixStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    suffixStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    counterStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    floatingLabelStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    labelText: 'Hip Length (cm) (Optional)',
                                    labelStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                  ),
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      final hip = double.tryParse(value);
                                      if (hip == null || hip <= 0) {
                                        return 'Please enter a valid hip length';
                                      }
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      _hipLength = double.parse(value);
                                    }
                                  },
                                ),
                          
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    helperStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    errorStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    prefixStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    suffixStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    counterStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    floatingLabelStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    labelText: 'Hip Width (cm) (Optional)',
                                    labelStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                  ),
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      final hip = double.tryParse(value);
                                      if (hip == null || hip <= 0) {
                                        return 'Please enter a valid hip width';
                                      }
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      _hipWidth = double.parse(value);
                                    }
                                  },
                                ),
                          
                          
                                // Shoulder Length Input (Optional)
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    helperStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    errorStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    prefixStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    suffixStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    counterStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    floatingLabelStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                    labelText: 'Shoulder Length (cm) (Optional)',
                                    labelStyle: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle()),
                                  ),
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      final shoulder = double.tryParse(value);
                                      if (shoulder == null || shoulder <= 0) {
                                        return 'Please enter a valid shoulder length';
                                      }
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      _shoulderLength = double.parse(value);
                                    }
                                  },
                                ),
                          
                                SizedBox(height: 20),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_validateFields(requireAllFields: false)) {
                                        final heightStr = _height?.toString() ?? '';
                                        final ageStr = _age?.toString() ?? '';
                                        final genderStr = _gender?.toString() ?? '';
                                  
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            // builder: (context) => MainPage(
                                            //   camera: widget.camera,
                                            //   height: heightStr,
                                            //   age: ageStr,
                                            //   gender: genderStr,
                                            // ),
                                            builder: (context) => Pages(camera: widget.camera, height: heightStr, age: ageStr, gender: genderStr,),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Please fill all required fields')),
                                        );
                                      }
                                    },
                                    child: Text('Find Out', style: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle(color: Color(0xFF3A3A6A),)),),
                                  ),
                                ),
                                SizedBox(height: 20),
                                                
                                // Continue Button
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_validateFields(requireAllFields: true)) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => Need(height: _height.toString(), age: _age.toString(), gender: _gender.toString(), h1: _hipLength, h2: _hipWidth, s1: _shoulderLength, s2: "")),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Please fill all required fields')),
                                        );
                                      }
                                    },
                                    child: Text('Continue', style: GoogleFonts.eduVicWaNtBeginner(textStyle: TextStyle(color: Color(0xFF3A3A6A),)),),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Image.asset('measurementsGirl.png'),
          ],
        ),
      ),
    );
  }
}
