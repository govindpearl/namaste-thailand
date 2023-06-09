import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:namastethailand/ContactUs/contactus.dart';
import 'package:namastethailand/SplashScreen/splashScreen.dart';
import 'package:namastethailand/UserProfile/userprofile.dart';

class MyAppRouter {
  static GoRouter returnRouter(bool isAuth) {
    GoRouter router = GoRouter(
      routes: [
        GoRoute(path: '/', builder:((context, state)=> const SplashScreen())),
        GoRoute(
          name: MyAppRouteConstants.profileRouteName,
          path: '/profile',
          pageBuilder: (context, state) {
            return const MaterialPage(child: UserProfile());
          },
        ),
        GoRoute(
          name: MyAppRouteConstants.contactUsRouteName,
          path: '/contact_us',
          pageBuilder: (context, state) {
            return const MaterialPage(child: ContactUs());
          },
        )
      ],
/*
      errorPageBuilder: (context, state) {
        return const MaterialPage(child: ErrorPage());
      },
*/
    );
    return router;
  }
}

class MyAppRouteConstants {
  static const String splashScreen = 'splash';
  static const String aboutRouteName = 'about';
  static const String profileRouteName = 'profile';
  static const String contactUsRouteName = 'contact_us';
}