import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:namastethailand/Utility/sharePrefrences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthLogout{
  Future<void> logout() async {
    // sign out from Firebase
    // sign out from Google

    (Platform.isAndroid)? googleSignOut() : appleSignOut();
    await FirebaseAuth.instance.signOut();
    AppPreferences.clear();
  }

  googleSignOut() async {
    GoogleSignIn().signOut();
  }

  appleSignOut() {
    //SignInWithApple.
  }
}