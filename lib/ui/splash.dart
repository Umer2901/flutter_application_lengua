import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_lengua/ui/onboard1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () async {
      // Navigate to the next screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => onboard1()),
      );

      // Save a flag indicating that the app has been opened
      await saveAppOpenedFlag();
    });
  }

  // Function to save a flag indicating that the app has been opened
  Future<void> saveAppOpenedFlag() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('appOpened', true);
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        backgroundColor: Colors.white, // Set your desired background color
        body: Center(
          child: Image.asset(
            'assets/images/launga.png', // Your logo image
            width: 70.w, // Adjust the logo size as needed
            height: 70.h,
          ),
        ),
      );
    });
  }
}
