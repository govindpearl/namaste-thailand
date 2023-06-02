import 'dart:math';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpUs extends StatelessWidget {
  HelpUs({Key? key}) : super(key: key);

  Map<String, String> data = {
    "Tourist Police": "1155",
    "Police": "191",
    "Tourism Authority of Thailand": "1672",
    "Ambulance": "112",
    "Fire department": "999",
    "Thai Airways": "1566",
    "Air Ambulance": "02 586 7654"
  };

  final _random = Random();

  Color _getRandomColor() {
    return Color.fromRGBO(
      _random.nextInt(128),
      _random.nextInt(120),
      _random.nextInt(119),
      1,
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunch(phoneUri.toString())) {
      await launch(phoneUri.toString());
    } else {
      throw 'Could not launch phone call';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text("Help Us"),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            String key = data.keys.elementAt(index);
            String? value = data[key];
            return Card(
              elevation: 1,
              child: ListTile(
                splashColor: Colors.orangeAccent,
                title: Text(key),
                subtitle: Text(value!),
                onTap: () {
                  _makePhoneCall(value);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}