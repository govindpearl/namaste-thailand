import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:awesome_otp_screen/awesome_otp_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'api_services.dart';
import 'newPassword.dart';


class OtpScreenForgetPassword extends StatefulWidget {
  final String email;


  const OtpScreenForgetPassword({Key? key, required this.email}) : super(key: key);

  @override
  State<OtpScreenForgetPassword> createState() => _OtpScreenForgetPasswordState();
}

class _OtpScreenForgetPasswordState extends State<OtpScreenForgetPassword> {
  // late int confirmOtp;
  // final String apiUrl = 'https://test.pearl-developer.com/hostshine/public/api/user/forgot-password';
  // Future<void> forgotPassword() async {
  //
  //   final response = await http.post(Uri.parse(apiUrl), body: {'email': widget.email});
  //
  //   print(response);
  //
  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> data = jsonDecode(response.body);
  //     int  otp = data['otp'];
  //     confirmOtp = otp;
  //     print(otp);
  //
  //   } else {
  //     // Display an error message to the user
  //   }
  // }

  @override
  void initState() {

    // forgotPassword();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Future<String> validateOtp(String otp, ) async {
      await Future.delayed(const Duration(milliseconds: 2000));
      // int intOtp = int.parse(otp);
      if (otp == "1234") {
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return AlertDialog(
        //       title:  Icon(
        //           Icons.check_circle,
        //           color: Colors.green,
        //           size: 50.0,),
        //       content: Text('Forgot password successful!'),
        //       actions: [
        //         TextButton(
        //           child: Text('OK'),
        //           onPressed: () {
        //             Navigator.of(context).pop();
        //           },
        //         ),
        //       ],
        //     );
        //   },
        // );
        // Future.delayed(Duration(seconds: 10), () {
        //   Navigator.pushReplacement<void, void>(
        //     context,
        //     MaterialPageRoute<void>(
        //       builder: (BuildContext context) =>  NewPasswordSet(),
        //     ),
        //   );        });
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>  NewPasswordSet(email: widget.email,),
          ),
        );
        return "Done";
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email is not found')),
        );        return "The entered Otp is wrong";
      }
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),

      body: Padding(
          padding: EdgeInsets.all(0),
          child: SingleChildScrollView(
            child:  Container(
              height: MediaQuery.of(context).size.height,
              child: AwesomeOtpScreen.withGradientBackground(
                topColor: Colors.green.shade200,
                bottomColor: Colors.greenAccent.shade700,
                otpLength: 4,
                validateOtp: (otp) async {
                  EasyLoading.show();
                  Response? response = await Api.verifyOtp(otp: int.parse(otp));
                  print(response.toString());
                  EasyLoading.dismiss();
                  if (response == null){
                    EasyLoading.showToast('Unable to communicate to server');
                  }else if(response.data['status']=='true'){
                    EasyLoading.showToast('Otp Verified successfully!');
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>  NewPasswordSet(email: widget.email)));
                  }else {
                    EasyLoading.showToast('Wrong Otp!');
                  }
                  return 'null';
                },
                routeCallback: (context) {

                },
                themeColor: Colors.white,
                titleColor: Colors.white,
                title: "${widget.email}",
                subTitle: "Enter the code sent to \n ${widget.email}",
              ),
            ),
          )
      ),
    );
  }
}
