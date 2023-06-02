
import 'package:awesome_otp_screen/awesome_otp_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:namastethailand/UserProfile/userprofile.dart';

import '../Dashboard/dashboard.dart';



class OtpScreen extends StatefulWidget {
  final String email;


  const OtpScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
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
  //
  // @override
  // void initState() {
  //
  //   forgotPassword();
  //   super.initState();
  // }
  void moveToNextScreen(context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) =>  Dashboard()));
  }




  @override
  Widget build(BuildContext context) {
    Future<String> validateOtp(String otp, ) async {
      await Future.delayed(const Duration(milliseconds: 2000));

      // int intOtp = int.parse(otp);
      if (otp == "1234") {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title:  Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 50.0,),
              content: Text('Email Change successfully!'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        Future.delayed(Duration(seconds: 10), () {
          Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) =>  UserProfile(),
            ),
          );        });

        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>  UserProfile(),
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
        backgroundColor: Colors.orangeAccent.shade200,
        elevation: 0,
      ),

      body: Padding(
          padding: EdgeInsets.all(0),
          child: SingleChildScrollView(
            child:  Container(
              height: MediaQuery.of(context).size.height,
              child: AwesomeOtpScreen.withGradientBackground(
                topColor: Colors.orangeAccent.shade200,
                bottomColor: Colors.orangeAccent.shade700,
                otpLength: 4,
                validateOtp: validateOtp,
                routeCallback: moveToNextScreen,
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
