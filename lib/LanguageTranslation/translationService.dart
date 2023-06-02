import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';

class MyThaiVoiceButton extends StatelessWidget {
  final String text;
  final String textMeans;


  MyThaiVoiceButton({Key? key, required this.text, required this.textMeans}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => _speakThai(context),
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                color: Colors.orangeAccent,

                borderRadius: BorderRadius.circular(15)
            ),
            height: 40,
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Row(
                children: [
                  Text(text, style: GoogleFonts.ptSerif(color: Colors.white),),
                  SizedBox(width: 15,),
                  Text(textMeans, style: GoogleFonts.ptSerif(color: Colors.white),),

                ],
              ),
            )),
      ),
    );
  }

  void _speakThai(BuildContext context) async {
    final flutterTts = FlutterTts();
    await flutterTts.setLanguage('th-TH');
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }
}