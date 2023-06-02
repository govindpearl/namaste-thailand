import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlaceContent extends StatelessWidget {
  final String imagePath;
  final String place;
  final VoidCallback onTab;
  const PlaceContent({Key? key, required this.imagePath, required this.place, required this.onTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
        children:[
          InkWell(
          onTap: onTab,
          child: Container(
            width: double.infinity,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(imagePath,
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: 250,

                ),

              ],

            ),
          ),
        ),
          Positioned(
              top: 125,
              left: 0,
              right: 0,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(place, style: GoogleFonts.merriweather(color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w800, fontSize: 18),),
                ],
              ))
        ]
    );
  }
}
