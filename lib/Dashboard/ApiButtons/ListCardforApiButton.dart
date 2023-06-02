import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonPlaceCard extends StatelessWidget {
  final String imagePath;
  final String place;
  final VoidCallback onTab;
  const ButtonPlaceCard({Key? key, required this.imagePath, required this.onTab, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      InkWell(
      onTap: onTab,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        width: double.infinity,
        height: 180,
        decoration:  BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [ BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                blurRadius: 5
            )

            ]
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 180,
                width: 180,
                color: Colors.transparent,
                child: Image.asset(imagePath,
                  fit: BoxFit.fill,
                  scale: 0.15,

                ),
              ),
              SizedBox(width: 10,),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 5,),

                    Flexible(child: Text(place, style: GoogleFonts.poppins(fontSize: 12 ,fontWeight: FontWeight.w300, color: Colors.black),)),
                  ],
                    ),
              )
                ],
              ),




          ),
        ),

      );
  }
}
