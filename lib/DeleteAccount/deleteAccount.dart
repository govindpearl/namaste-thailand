import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../Utility/logout.dart';
import '../Utility/sharePrefrences.dart';
import '../login.dart';

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({Key? key}) : super(key: key);

  void deleteAccount(BuildContext context) async {
    final dio = Dio();
    dio.options.baseUrl = 'https://test.pearl-developer.com/thaitours/public/api/';

    final headers = {
      'Authorization': 'Bearer ${AppPreferences.getUserId()}',
    };

    try {
      final response = await dio.post('delete-account', options: Options(headers: headers));

      if (response.statusCode == 200) {
        // Account deletion successful
        await AuthLogout().logout(); // Log out the user
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else {
        // Handle error response
        print('Error deleting account: ${response.statusMessage}');
      }
    } catch (e) {
      // Handle network or other errors
      print('Error deleting account: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delete Account"),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
      ),

      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 8,),
            Container(
              height: 50,
              width: double.infinity,
              child: Card(
                elevation: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(width: 0.1,),
                    Text("Delete Account", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),),
                    IconButton(
                      onPressed: (){
                        showDeleteConfirmationDialog(context);

                      },
                      icon: Icon(Icons.delete, color: Colors.red,),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Account Deletion"),
          content: Text("Are you sure you want to delete your account permanently? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () {
                // User clicked on "Cancel" button
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: ()  {
                deleteAccount(context);       // Show a success message or navigate to a different screen
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

}
