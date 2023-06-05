import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:namastethailand/Dashboard/dashboard.dart';

import '../GateWayPayment/app_in_purchase.dart';
import '../GateWayPayment/paypal.dart';
import 'dart:io' as io;


class RegisterStatus extends StatelessWidget {
  const RegisterStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Thank you "),
                SizedBox(height: 10,),
                Text("Your Shop is registered with us successfully."),
                SizedBox(height: 10,),
                Text("Your application status is pending "),
                SizedBox(height: 10,),
                Text("Please wait we will connect with you shortly."),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
/*
                    ElevatedButton(onPressed: (){
                      if (io.Platform.isMacOS) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppInPurchaseScreen(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PayPalScreen(title: 'kk'),
                          ),
                        );
                      }
                    }, child: Text("Continue")),
*/
                    ElevatedButton(onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Dashboard(),
                        ),
                      );
                    },child: Text("Go Home"),)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//jkjkdkjk