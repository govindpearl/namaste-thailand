import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:namastethailand/Utility/sharePrefrences.dart';

import '../widget/api_services.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {

  TextEditingController _subject = TextEditingController(text: '');
  TextEditingController _description = TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:
      AppBar(
        title: Text("Contact Us"),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
      ),
      backgroundColor:Colors.grey[200],
      body: SafeArea(
          child: Center(
            child: BlurryContainer(elevation: 1,
              color: Colors.grey.shade300,
              height: MediaQuery.of(context).size.height*0.6,
              width: MediaQuery.of(context).size.width*0.8,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20,),
                      Text("Get In Touch", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),),
                      SizedBox(height: 10,),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                            color: Colors.white70,
                            width: 1.0,
                          ),
                        ),
                        child: TextFormField(
                          controller: _subject,
                          decoration: InputDecoration(
                              hintText: 'Subject',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 10)
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a subject';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                            ),
                          ),
                          child: TextFormField(
                            controller: _description,
                            maxLines: 100,
                            minLines: 4,
                            decoration: InputDecoration(
                              hintText: 'Enter message',
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a message';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),


                      SizedBox(height: 20,),
                      ElevatedButton(onPressed: () async {

                        if (_formKey.currentState!.validate()) {
                          print(AppPreferences.getUserId());
                          EasyLoading.show();
                          Response? response = await Api.customer_support(msg: _description.text, subject: _subject.text);
                          EasyLoading.dismiss();

                          if(response == null){
                            EasyLoading.showToast('Unable to communicate to server');
                          }else if(response.data['status']=='true'){
                            EasyLoading.showToast('Your request submitted successfully,\nplease wait we will connect with you soon');
                            _description.clear();
                            _subject.clear();
                          }
                        else  if(response.data['status']=="false"){
                            return EasyLoading.showToast("Message not sent");
                          }

                          else{
                            EasyLoading.showToast('Unable to process your request');
                          }
                        }

    }, child: Text("Send"))
                    ],
                  ),
                ),
              ),


            ),
          )),

    );
  }
}