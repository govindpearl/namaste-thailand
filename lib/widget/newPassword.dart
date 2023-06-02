import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:namastethailand/login.dart';

import 'api_services.dart';

class NewPasswordSet extends StatefulWidget {

  final email;
  const NewPasswordSet({Key? key, required String this.email}) : super(key:key);
  @override
  _NewPasswordSetState createState() => _NewPasswordSetState();
}

class _NewPasswordSetState extends State<NewPasswordSet> {
  final _formKey = GlobalKey<FormState>();


  TextEditingController _password = TextEditingController(text: '');
  TextEditingController _cpassword = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    controller: _password,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'New Password',
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),

                    ),

                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter new password';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    controller: _cpassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Confirm Password',
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),

                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please confirm password';
                      } else if (value != _password.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10,),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(

                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // TODO: Reset password logic goes here

                        EasyLoading.show();
                        Response? response = await Api.changePassword(email: widget.email, newPassword: _password.text, oldPassword: '');
                        EasyLoading.dismiss();
                        print(response.toString());
                        if (response == null){
                          EasyLoading.showToast('Unable to communicate to server');
                        }else if(response.data['status'] == true){
                          EasyLoading.showToast('Password change successfully');
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>  Login(),), (route) => false,);
                        }else {
                          EasyLoading.showToast('Unable to change password');
                        }
                      }
                    },
                    child: Text('Reset Password'),
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