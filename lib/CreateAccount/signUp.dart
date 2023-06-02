import 'dart:convert';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:namastethailand/login.dart';
import '../Dashboard/dashboard.dart';
import '../Utility/sharePrefrences.dart';
import 'package:http/http.dart' as http;
class SignUp extends StatefulWidget {

  const SignUp({Key? key,}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  bool ConfirmvisiblePassword = false;
  var obscureText = true;

  bool visiblePassword = false;
  var passwordObscure = true;
  late String UserEmail;
  late String UserName;
  late String UserProfilePic;
  late String UserId;



/*
  Future<void> signInWithGooogle() async{
    print("method running 1");
    FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser!.authentication;
    print("method running 2");

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential userCredential =
    await auth.signInWithCredential(credential);
    print("method running 3");


    if (googleUser != null && googleUser.id != null && googleUser.displayName != null && googleUser.email != null && googleUser.photoUrl != null) {
      // User is signed in and has all the required properties
      AppPreferences.setUserProfile(googleUser.id, googleUser.displayName!, googleUser.email, googleUser.photoUrl!);
      print("User signed in successfully");
    } else {
      // User is not signed in or is missing required properties
      print("User sign-in failed or missing required properties");
    }
  }
*/


  Dio dio = Dio();

  void _onSubmit() async {
    // Validate form data
    EasyLoading.show(status: "please wait");
    if (username.text.isEmpty ||
        _email.text.isEmpty ||
        Pass_Controller.text.isEmpty ||
        CpassController.text.isEmpty ||
        mobile_no.text.isEmpty) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all the fields')),
      );
      return;
    }

    if (Pass_Controller.text != CpassController.text) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password and Confirm Password do not match')),
      );
      return;
    }

    // Make a POST request to the SignUp API
    try {
      final response = await dio.post(
        'https://test.pearl-developer.com/thaitours/public/api/create-user',
        data: {
          'username': username.text,
          'email': _email.text,
          'password': Pass_Controller.text,
          'mobile_no': mobile_no.text,
        },
      );




      if (response.data['status'] == "true") {
        String userId = response.data["token"];
        String displayName = response.data['user']['name'];
        String userEmail = response.data['user']['email'];
        String phone_no = response.data['user']['mobile_no'];
        String msg = response.data['msg'];
         print("ture===="+msg);



        AppPreferences.setUserProfile(userId: userId, displayName:displayName, userEmail:userEmail, photoUrl: "", phone_no:phone_no);
        EasyLoading.dismiss();
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const Dashboard(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome to Thailand tour')),
        );
      }
      else if(response.data['status']=="false")   {
        String msg = response.data['msg'];
        print("FALSE===="+msg);
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.data["msg"].toString()),
          backgroundColor: Colors.red,
          )
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()),
        backgroundColor: Colors.red,
        ),
      );

      print(e);
    }
 }

  @override
    TextEditingController CpassController = TextEditingController();
  TextEditingController Pass_Controller = TextEditingController();
  TextEditingController mobile_no = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController username = TextEditingController();


  Widget build(BuildContext context) {
    bool _isHovering = false;

     return Scaffold(
       backgroundColor:Colors.grey[200],
       appBar: AppBar(
         backgroundColor: Colors.grey[200],
         elevation: 0,
         iconTheme: IconThemeData(color: Colors.black),
       ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Container(
                  width: double.infinity,
                  child: Center(child: Text("Create An Account", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 30, letterSpacing: 1),)),
                ),
                SizedBox(height: 20,),
                Container(
                  width: double.infinity,
                  child: Center(child: Text("Namaste Thailand", style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.w800, fontSize: 22, letterSpacing: 1),)),
                ),

                SizedBox(height: 20,),

                Padding(
                  padding: const EdgeInsets.only(left: 17, right: 17),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: Colors.blueGrey,
                            width: 1.0,
                            style: BorderStyle.solid
                        )
                    ),
                    child:  TextFormField(
                      controller: username,
                      decoration: InputDecoration(
                        alignLabelWithHint: false,
                        filled: true,
                        hintText: "User Name",
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.person, color: Colors.blueGrey,),


                      ),
                    )
                  ),
                ),

                SizedBox(height: 20,),

                Padding(
                  padding: const EdgeInsets.only(left: 17, right: 17),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: Colors.blueGrey,
                            width: 1.0,
                            style: BorderStyle.solid
                        )
                    ),
                    child:  TextFormField(
                      controller: mobile_no,
                      decoration: InputDecoration(
                        alignLabelWithHint: false,
                        filled: true,
                        hintText: "Mobile Number",
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.phone, color: Colors.blueGrey,),


                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),

                Padding(
                  padding: const EdgeInsets.only(left: 17, right: 17),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: Colors.blueGrey,
                            width: 1.0,
                            style: BorderStyle.solid
                        )
                    ),
                    child: TextFormField(
                      controller: _email,
                      decoration: InputDecoration(
                        alignLabelWithHint: false,
                        filled: true,
                        hintText: "Email Address",
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.email, color: Colors.blueGrey,),


                      ),
                    )
                  ),
                ),
                SizedBox(height: 20,),

                Padding(
                  padding: const EdgeInsets.only(left: 17, right: 17),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: Colors.blueGrey,
                            width: 1.0,
                            style: BorderStyle.solid
                        )
                    ),
                    child: TextFormField(
                      controller: Pass_Controller,
                      obscureText: passwordObscure,

                      decoration: InputDecoration(
                          hintText: 'Password',
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.lock, color: Colors.blueGrey,),
                          suffixIcon:IconButton(
                            icon: visiblePassword ? Icon(Icons.visibility,color: Colors.blueGrey,) : Icon(Icons.visibility_off, color: Colors.blueGrey,),
                            onPressed: () {
                              setState(
                                    () {
                                  passwordObscure = !passwordObscure;
                                  if(visiblePassword){
                                    visiblePassword = false;
                                  }
                                  else{
                                    visiblePassword = true;
                                  }
                                },
                              );
                            },
                          ),
                          alignLabelWithHint: false,
                          filled: true
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),

                Padding(
                  padding: const EdgeInsets.only(left: 17, right: 17),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: Colors.blueGrey,
                            width: 1.0,
                            style: BorderStyle.solid
                        )
                    ),
                    child: TextField(
                      controller: CpassController,
                      obscureText: obscureText,

                      decoration: InputDecoration(
                          hintText: 'ConfirmPassword',

                          border: InputBorder.none,
                        prefixIcon: Icon(Icons.lock, color: Colors.blueGrey,),
                        suffixIcon:IconButton(
                          icon: ConfirmvisiblePassword ? Icon(Icons.visibility,color: Colors.blueGrey,) : Icon(Icons.visibility_off, color: Colors.blueGrey,),
                          onPressed: () {
                            setState(
                                  () {
                                obscureText = !obscureText;
                                if(ConfirmvisiblePassword){
                                  ConfirmvisiblePassword = false;
                                }
                                else{
                                  ConfirmvisiblePassword = true;
                                }
                              },
                            );
                          },
                        ),
                          alignLabelWithHint: false,
                          filled: true
                      ),
                    )
                    ),
                  ),
                SizedBox(
                  height: 20,

                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        print("signUpButtonTab");
                        if (_formKey.currentState!.validate()) {
                          print("formkey checking");
                          _onSubmit();
                        }                 },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 24.0,
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.orangeAccent,
                        ),
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
