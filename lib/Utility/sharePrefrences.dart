


import 'package:shared_preferences/shared_preferences.dart';


class AppPreferences {
  // static late String? langValue;
   static late SharedPreferences _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }



  /// setUserProfile
  static void setUserProfile({required String userId, required String displayName, required String userEmail, required String photoUrl, required String phone_no}) {
    _preferences.setString("userId", userId);
    _preferences.setString("displayName", displayName);
    _preferences.setString("userEmail", userEmail);
    _preferences.setString("userProfileUrl", photoUrl);
    _preferences.setString("mobile_no", phone_no);

    _preferences.setBool("isLogin", true);

  }
   static String getUserPhoneNo() {

     String? s = _preferences.getString("mobile_no") ?? '';
     return s;
   }
  static String getUserProfile() {

    String? s = _preferences.getString("userProfileUrl") ?? '';
    return s;
  }
  static String getUserId() {

    String? s = _preferences.getString("userId") ?? '';
    return s;
  }
  static String? getUserEnail() {

    String? s = _preferences.getString("userEmail") ?? '';
    return s;
  }
  static String getUserDisplayName() {

    String? s = _preferences.getString("displayName") ?? '';
    return s;
  }

  static void clear() {
    _preferences.clear();
    setShowOnBoarding(show: false);

  }

  static bool getShowOnBoarding() {
    bool s = _preferences.getBool("showOnBoarding") ?? true;
    return s;
  }

   static void setShowOnBoarding({required bool show}) {
     _preferences.setBool("showOnBoarding", show);
   }

  static bool getLoginStatus() {
    bool s = _preferences.getBool("isLogin") ?? false;
    return s;
  }
   static void setShopAddress({required String address}) {
     _preferences.setString("address", address);

   }
   static String getShopAddress() {

     String? s = _preferences.getString("address") ?? '';
     return s;
   }

}