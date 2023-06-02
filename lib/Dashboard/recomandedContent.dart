import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecomandedContent extends StatefulWidget {
  final String imagePath;
  final String place;
  final VoidCallback onTab;
  const RecomandedContent({Key? key, required this.imagePath, required this.place, required this.onTab}) : super(key: key);

  @override
  State<RecomandedContent> createState() => _RecomandedContentState();
}

class _RecomandedContentState extends State<RecomandedContent> {
  @override
  Widget build(BuildContext context) {
    return
      Column(
          children:[ InkWell(
            onTap: widget.onTab,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Card(
                  color: Colors.grey[200],
                  shape: RoundedRectangleBorder(

                    borderRadius: BorderRadius.circular(5.0), //<-- SEE HERE
                  ),
                  margin: EdgeInsets.all(2),
                  child:
                  Container(
                    width: 180,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image.network(widget.imagePath,
                            fit: BoxFit.fill,
                            width: 178,
                            height: 120,

                          ),
                        ),
                        SizedBox(height: 2,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(widget.place, style: GoogleFonts.merriweather(color: Colors.orangeAccent.withOpacity(0.9), fontWeight: FontWeight.w800, fontSize: 18),),
                          ],
                        ),
                        SizedBox(height: 5,)
                      ],

                    ),
                  )

              ),
            ),
          ),

          ]
      );
  }
}
