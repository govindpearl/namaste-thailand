import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Utility/sharePrefrences.dart';
import '../dashboard.dart';


class WelcomeApiButton extends StatefulWidget {
  final String id;
   WelcomeApiButton({Key? key,required this.id}) : super(key: key);

  @override
  State<WelcomeApiButton> createState() => _WelcomeApiButtonState();
}

class _WelcomeApiButtonState extends State<WelcomeApiButton> {
  // Location location = Location();
  final cityCategoryDesc = FutureProvider.family((ref,String id) async {
    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer ${AppPreferences.getUserId()}';

    try {
      final response = await dio.post(
        'https://test.pearl-developer.com/thaitours/public/api/more-category-content',
        data: {'id': int.parse(id)}, // Replace `yourId` with the actual id value you want to send
      );

      return response;
    } on DioError catch (e) {

      return e.response;
    }
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async{
          final String shopAddress = AppPreferences.getShopAddress();
          final String encodedAddress = Uri.encodeComponent(shopAddress);
          final String mapUrl =
              'https://www.google.com/maps/search/?api=1&query=$encodedAddress';
          if (await canLaunch(mapUrl)) {
            await launch(mapUrl);
          } else {
            // If Google Maps app is not installed, open in web browser
            final String webMapUrl =
                'https://www.google.com/maps/search/?api=1&query=$encodedAddress';
            if (await canLaunch(webMapUrl)) {
              await launch(webMapUrl);
            } else {
              throw 'Could not launch $webMapUrl';
            }
          }

        },
        backgroundColor: Colors.orangeAccent,
        label:Text("Navigate",style: GoogleFonts.ptSerif(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w500),),
        icon: Icon(Icons.location_on),
        elevation: 20,

      ),
      body: SafeArea(
        child: Column(
         mainAxisAlignment: MainAxisAlignment.start,
         crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [Container(
                height: MediaQuery.of(context).size.height*0.4,
                width: double.infinity,
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                      ),

                child: Consumer(
                  builder: (context, watch, _) {
                    final citiesFuture = watch.watch(cityCategoryDesc(widget.id));

                    return citiesFuture.when(
                      data: (response) {
                         if (response==null){
                           return Container(child: Center( child: Text("Unable to communicate"),), );
                         }
                         if(response.data['status']=='true'){
                           final cities = response.data['details'];
                           return SizedBox(

                             // Your desired size for the container
                             child: ClipRRect(
                               borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight:Radius.circular(30)),
                               child:
                               cities["image"] != ""
                                   ? Image.network(cities["image"], fit: BoxFit.fill)
                                   : Image.asset("assets/images/spa2.jpg", fit: BoxFit.fill),
                             ),

                           );
                         }
                         else if(response.data['status']=='false'){
                           return Text("No data is found");
                         }
                         else{
                           return Text(response.toString());
                         }




                      },
                      loading: () => Center(child: Container(
                          height: 50,
                          width:50,
                          child: CircularProgressIndicator())),
                      error: (error, _) => Text('Error: $error'),
                    );
                  },
                )


              ),
      Positioned(
          top: 16,
          left: 16,
          child: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              height: 30,
              width: 30,


              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Icon(Icons.arrow_back,color: Colors.white),

            ),
          ),
      ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: IconButton(
                    icon: Icon(Icons.home,color: Colors.orangeAccent,),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Dashboard()),
                      );                    },
                  ),
                )
      ]
            ),
            SizedBox(height: 10,),


            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child :   Consumer(
                    builder: (context, watch, _) {
                      final citiesFuture = watch.watch(cityCategoryDesc(widget.id));

                      return citiesFuture.when(
                        data: (response) {
                          if(response==null){
                            return Text("Unable to communicate server");
                          }
                           else if(response.data['status']=="true")
                            {
                              final cities = response.data['details'];
                              AppPreferences.setShopAddress(address: cities['address']);
                              return SizedBox(

                                // Your desired size for the container
                                child:                     Column(
                                  children: [
                                    BlurryContainer(
                                      color: Colors.grey.shade200,
                                      elevation: 1,
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("ShopName", style: GoogleFonts.ptSerif(
                                                  fontSize: 17, fontWeight: FontWeight.w500,
                                                  color: Colors.blueGrey,
                                                  letterSpacing: 2
                                              ),),
                                              Text(cities['shop_name'], style: GoogleFonts.ptSerif(
                                                  fontSize: 15, fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                  letterSpacing: 2
                                              ),),],
                                          ),
                                          SizedBox(height: 5,),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                            children: [
                                              Text("Price", style: GoogleFonts.ptSerif(
                                                  fontSize: 17, fontWeight: FontWeight.w400,
                                                  color: Colors.blueGrey,
                                                  letterSpacing: 2
                                              ),),
                                              SizedBox(height: 5,),
                                              Text("\$${cities['price']}", style: GoogleFonts.ptSerif(
                                                  fontSize: 15, fontWeight: FontWeight.w400,
                                                  color: Colors.red,
                                                  letterSpacing: 2
                                              ),),
                                            ],
                                          ),
                                          SizedBox(height: 5,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Contact", style: GoogleFonts.ptSerif(
                                                  fontSize: 17, fontWeight: FontWeight.w400,
                                                  color: Colors.blueGrey,
                                                  letterSpacing: 2
                                              ),),
                                              Text(cities['contact'], style: GoogleFonts.ptSerif(
                                                  fontSize: 15, fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                  letterSpacing: 2
                                              ),),
                                            ],
                                          )

                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5,),


                                    BlurryContainer(
                                      width: double.infinity,
                                      color: Colors.grey.shade200,
                                      elevation: 1,
                                      child: Column(
                                        children: [
                                          Text("About", style: GoogleFonts.ptSerif(
                                              fontSize: 17, fontWeight: FontWeight.w400,
                                              color: Colors.blueGrey,
                                              letterSpacing: 2
                                          ),),
                                          Html(data: cities['description'],style: {
                                            'body': Style(
                                              fontSize: FontSize(15),
                                              fontWeight: FontWeight.w400,
                                              color: Colors.blueGrey,
                                              letterSpacing: 1,
                                            ),
                                          },
                                          )
                                          /*Text(cities['description'],
                                          style: GoogleFonts.ptSerif(
                                              fontSize: 15, fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              letterSpacing: 2
                                          ),)*/

                                        ],
                                      ),

                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    BlurryContainer(
                                      width: double.infinity,
                                      color: Colors.grey.shade200,
                                      elevation: 1,
                                      child: Column(
                                        children: [
                                          Text("Address", style: GoogleFonts.ptSerif(
                                              fontSize: 20, fontWeight: FontWeight.w400,
                                              color: Colors.blueGrey,
                                              letterSpacing: 2
                                          ),),
                                          Text(cities['address'], style: GoogleFonts.ptSerif(
                                              fontSize: 20, fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              letterSpacing: 2
                                          ),),

                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Container(
                                      height: 100,
                                      width: double.infinity,
                                    )
                                  ],
                                ),

/*ListTile(
                                  title: Text(city['cityname']),
                                  // Add other widgets to display additional information about the city, such as the image
                                );*//*

                                        },
                                      ) : Text('No Data'),
*/
                              );
                            }
                           else if(response.data["status"]=="false"){
                             return Container(
                                 child: Center(child: Text('No Data found!'),
                          ) );
                          }
                           else{
                             return Container( child: Center(child: Text(response.toString()),),);
                          }



                        },
                        loading: () => Center(child: Container(
                            height: 50,
                            width:50,
                            child: CircularProgressIndicator())),
                        error: (error, _) => Text('Error: $error'),
                      );
                    },
                  )


                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
