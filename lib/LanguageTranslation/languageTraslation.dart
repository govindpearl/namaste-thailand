import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:namastethailand/LanguageTranslation/translationService.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LanguageTranslator extends StatefulWidget {
  const LanguageTranslator({Key? key}) : super(key: key);

  @override
  State<LanguageTranslator> createState() => _LanguageTranslatorState();
}
late final String Namaste;

class _LanguageTranslatorState extends State<LanguageTranslator> {
  late WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Thai Translator"),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.orangeAccent,
          elevation: 0,
        ),
        body: SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: WebView(
              initialUrl:
                  'https://translate.google.co.in/?sl=en&tl=th&text=Namste%0A&op=translate',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller = webViewController;
              },
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
              flex: 2,
              child: Container(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    MyThaiVoiceButton(text: "Thạkthāy",textMeans: "Namaste"),
                    SizedBox(height: 10,),
                    MyThaiVoiceButton(text: "Phī̀ chāy",textMeans:"bhai" ),
                    SizedBox(height: 10,),
                    MyThaiVoiceButton(text: "Khuṇ pĕn xỳāngrị b̂āng",textMeans:"kaise ho app" ),


                  ],
                ),
              ))
        ],
      ),
    ));
  }
  void _speakThai(BuildContext context) async {
    final flutterTts = FlutterTts();
    await flutterTts.setLanguage('th-TH');
    await flutterTts.setSpeechRate(1.0);
    await flutterTts.speak(Namaste);
  }
}
