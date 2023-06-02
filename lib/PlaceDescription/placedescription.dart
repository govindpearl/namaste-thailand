import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlaceDescription extends StatelessWidget {
  const PlaceDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
            Image.asset("assets/images/RamaBridge.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: 250,),
              SizedBox(height: 5,),
              Text("The Rama VIII Bridge",
                style: GoogleFonts.notoSansAnatolianHieroglyphs(
                    color: Colors.black,
                    fontSize: 20,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w700),),
              SizedBox(height: 5,),
              Text(
                  "Getting stuck in traffic can be a heck lot annoying and frustrating at times, especially when you are in a rush. Worry not, for your desire to skip all that and sail "
                      "over the massive congestion is made possible by the BTS(Sky Train), MRT(Subway) and Airport Link of Bangkok",
                  style: GoogleFonts.libreBaskerville(
                      letterSpacing: 1, color: Colors.blueGrey)),

              SizedBox(height: 10,),


              Image.asset("assets/images/river.jpg",
                fit: BoxFit.fill,
                width: double.infinity,
                height: 250,),
              SizedBox(height: 5,),
              Text("Chao Phraya River",
                style: GoogleFonts.notoSansAnatolianHieroglyphs(
                    color: Colors.black,
                    fontSize: 20,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w700),),
              SizedBox(height: 5,),
              Text(
                  "Chao Phraya River, Thai Mae Nam Chao Phraya, also called Maenam, principal river of Thailand. It flows south through the nation’s fertile "
                      "central plain for more than 225 miles (365 km) to the Gulf of Thailand. Thailand’s capitals, past and present (Bangkok), have "
                      "all been situated on its banks or "
                      "those of its tributaries and distributaries, as are many other cities",
                  style: GoogleFonts.libreBaskerville(
                      letterSpacing: 1, color: Colors.blueGrey)),

            ],
          ),
        ),
      ),
    );

  }
}
