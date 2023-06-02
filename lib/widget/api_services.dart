import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:namastethailand/Utility/sharePrefrences.dart';

class Api {

  static String _base_url = 'https://test.pearl-developer.com/thaitours/public/api/';

  static final _dio = Dio(
    BaseOptions(baseUrl:  _base_url, contentType:  'application/json', headers: { 'Authorization': 'Bearer ${AppPreferences.getUserId()}'}),
  );



  static const String _login_url = 'login';
  static const String _send_otp_url = 'forgot-password';
  static const String _verify_otp_url = 'verify-otp';
  static const String _change_password_url = 'reset-password';
  static const String _customer_support_url = 'contact-us';
  static const String _get_cities_url = 'get-cities';
  static const String _add_shop_url = 'add-shop';


  static Future<Response?> forgotPassword({required String email}) async {

    try{
      Response response = await _dio.post(_send_otp_url, data: jsonEncode({'email': email,}));
      return response;
    }on DioError catch (e){
      print(e.toString());
      return e.response;
    }
  }
  static Future<Response?> changePassword({required String oldPassword, required String newPassword, required String email}) async {

    try{
      Response response = await _dio.post(_change_password_url, data: jsonEncode({'email': email, 'old_password': oldPassword, 'password': newPassword}));
      return response;
    }on DioError catch (e){
      print(e.toString());
      return e.response;
    }
  }
  static Future<Response?> verifyOtp({required int otp}) async {

    try{
      Response response = await _dio.post(_verify_otp_url, data: jsonEncode({'otp': otp,}));
      return response;
    }on DioError catch (e){
      print(e.toString());
      return e.response;
    }
  }
  static Future<Response?> signInWithOptions({String? email, String? idToken, String? name, required String type, String? appleId, String? password}) async {

    try {
      final response = await _dio.post(
        _login_url,
        //options: Options(headers: {'Content-Type': 'application/json'}),
        data: json.encode({
          'email': email??'',
          'password': password??'',
          'client_token': idToken??'',
          'username': name??'',
          'type': type,
          'appleId': appleId??''
        }),
      );

      if (response.data['status']==201) {
        _saveUserData(response);
      } else {
        print('Sign in with options failed. Status code: ${response.statusCode}, ${response.data}');
      }
      return response;
    } on DioError catch (error) {
      // Handle any exceptions or errors that occur during the API call
      print('An error occurred during the API call: $error');
      return error.response;
    }
  }
  static Future<Response?> customer_support({required String msg, required String subject}) async {

    try{
      Options options = Options(
          headers: { 'Authorization': 'Bearer ${AppPreferences.getUserId()}'}
      );
      Response response = await _dio.post(_customer_support_url, data: jsonEncode({'subject': subject, 'message': msg}), options: options);
      return response;
    }on DioError catch (e){
      print(e.toString());
      return e.response;
    }
  }
  static Future<Response?> addShop({required int cityId, required String shopName, required String shopType, required String place}) async {

    try{
      Options options = Options(
          headers: { 'Authorization': 'Bearer ${AppPreferences.getUserId()}'}
      );
      Response response = await _dio.post(_add_shop_url, data: jsonEncode({
        'shopname': shopName,
        'city_id': cityId,
        'shoptype': shopType,
        'place': place,
      }),
      options: options
      );
      return response;
    }on DioError catch (e){
      print(e.toString());
      return e.response;
    }
  }
  static Future<Response?> getCities() async {

    try{
      Options options = Options(
          headers: { 'Authorization': 'Bearer ${AppPreferences.getUserId()}'}
      );
      Response response = await _dio.get(_get_cities_url,options: options);
      return response;
    }on DioError catch (e){
      print(e.toString());
      return e.response;
    }
  }

  static Future<void> _saveUserData(Response response) async {
AppPreferences.setUserProfile(
    userId: response.data['token'],
    displayName: response.data['user']['name'],
    userEmail: response.data['user']['email'],
    photoUrl: response.data['user']['user_profile'] ?? '',
    phone_no: response.data['user']['mobile_no'] .toString()?? '');
    print(response.toString());

    /*if(response.data['user']['user_profile'] != null || response.data['user']['user_profile'] != '') {
    downloadProfileImage(url: response.data['user']['user_profile']);
  }*/

  }


}
