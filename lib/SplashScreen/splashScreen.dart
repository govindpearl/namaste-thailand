import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:namastethailand/Dashboard/dashboard.dart';
import 'package:namastethailand/onBoardingScreen/onBoardingScreen.dart';

// import '../Utility/sharePrefrences.dart';
import '../Dashboard/dashboard.dart';
import '../Utility/sharePrefrences.dart';
import '../login.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {


    super.initState();
    Timer(const Duration(seconds: 3), () {
      redirectUser();
    });
  }
  Future<void> redirectUser() async {
    User? user =  FirebaseAuth.instance.currentUser;
    if(AppPreferences.getShowOnBoarding()){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
      );
    }else if (AppPreferences.getLoginStatus()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedSplashScreen(
            duration: 3000,
            splash:  Image(
              image: AssetImage(
                "assets/icons/namasteThai.png",
              ),
            ),
            nextScreen: const OnBoardingScreen(),
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: Colors.white));
  }
}
