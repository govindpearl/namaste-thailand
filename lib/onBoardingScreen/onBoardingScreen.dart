import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:namastethailand/Utility/sharePrefrences.dart';
import 'package:namastethailand/onBoardingScreen/onBoardContent.dart';

import '../login.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentIndex = 0;
  late PageController _controller;
  @override
  void initState(){
    AppPreferences.setShowOnBoarding(show: false);
    _controller = PageController(initialPage: 0);
    super.initState();
  }
@override

void dispose(){
    _controller.dispose();
    super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
          itemCount: contents.length,
          onPageChanged: (int index){
            setState(() {
              currentIndex = index;
            });
          },
          itemBuilder: (_,i){
            return Stack(
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Image.asset(contents[i].image, fit: BoxFit.cover,),
                ),
                Positioned(
                    bottom: 50,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: BlurryContainer(
                        color: Colors.white.withOpacity(0.3 ),
                        width: MediaQuery.of(context).size.width*0.8,
                        height: 240,
                        elevation: 5,
                        blur: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(contents[i].title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30,),),
                            SizedBox(height: 10,),
                            Container(
                                child: Text(contents[i].discription ,style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.w200, letterSpacing: 1),textAlign: TextAlign.center,),),

                          ],
                        ),

                      ),
                    )
                ),
                Positioned(
                    bottom: 100,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(contents.length, (index) => buildDot(index, context)
                        )
                      ),
                    )),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: (){
                        if(currentIndex== contents.length - 1){
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()));
                        }
                        _controller.nextPage(duration: Duration(microseconds: 100),
                            curve: Curves.bounceIn);
                      },
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            color: Colors.amber,

                            borderRadius: BorderRadius.all(Radius.circular(40))
                        ),
                        child: Center(
                          child: Icon(Icons.arrow_forward, color: Colors.white,),
                        ),
                        ),
                    ),
                  ),
                ),

              ],
            );
          }),

    );


  }

  Container buildDot (int index, BuildContext context){
    return Container(
        height: 10,
        width: currentIndex == index ? 25:10,
        margin: EdgeInsets.only(right: 5),
    decoration: BoxDecoration(
    color: Colors.red,
    borderRadius: BorderRadius.circular(20)
    ),
    );
  }

}


