import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_lengua/ui/call.dart';
import 'package:flutter_application_lengua/ui/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_lengua/ui/onboard1.dart';
import 'package:flutter_application_lengua/ui/splash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF007AFF)),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: checkAppOpened(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while checking the app opened status
            return CircularProgressIndicator();
          } else {
            // Check the app opened status and navigate accordingly
            return snapshot.data == true ? SplashScreen() : Homepage();
          }
        },
      ),
    );
  }

  // Function to check whether the app has been opened before
  Future<bool> checkAppOpened() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('appOpened') ?? false;
  }
}
