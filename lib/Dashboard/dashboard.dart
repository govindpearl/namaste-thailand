import 'dart:async';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:namastethailand/HelpLineNumber/helpus.dart';
import 'package:namastethailand/LanguageTranslation/languageTraslation.dart';
import 'package:namastethailand/UserProfile/userprofile.dart';
import 'package:namastethailand/Utility/logout.dart';
import 'package:namastethailand/Utility/sharePrefrences.dart';
import 'package:namastethailand/login.dart';
import '../AddShop/add_shop.dart';
import '../CityInformation/cityInformation.dart';
import '../ContactUs/contactus.dart';
import '../DeleteAccount/deleteAccount.dart';
import 'TimeWidget/indiaThaiTime.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  bool isLoading = true;
  String? inr;
  String? thb;
  List<Map<String, dynamic>> cityList = [];
  List<Map<String, dynamic>> advertisementList =[];


  final fetchCities = FutureProvider((ref) async {
    final dio = Dio();
    dio.options.headers['Authorization'] =
    'Bearer ${AppPreferences.getUserId()}';

    try {
      final response = await dio.get(
          'https://test.pearl-developer.com/thaitours/public/api/get-cities');

     return response;
    } on DioError catch (e) {
      return e.response;
    }
  });

  @override

  @override
  var indianTime;
  var thailandTime;
  List<String> imageNames = [
    'assets/images/hotel1.jpg',
    'assets/images/hotel2.jpg',
    'assets/images/newThai3.jpg',
  ];

  void getTime() {
    DateTime now = DateTime.now();

    // Indian Time
    this.indianTime = DateFormat('hh:mm:ss a')
        .format(now.toUtc().add(Duration(hours: 5, minutes: 30)));
    print('Indian Time: $indianTime');

    // Thailand Time
    this.thailandTime =
        DateFormat('hh:mm:ss a').format(now.toUtc().add(Duration(hours: 7)));
    print('Thailand Time: $thailandTime');
  }

 @override
  void initState() {
    super.initState();
    this.getTime();
    getConnectivity();
    fetchCurrencyData();
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
            (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }


  @override
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
          overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom,]);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
      ));
    });

    return Scaffold(
      backgroundColor: Colors.grey[300],
      drawer: drawer(
      ),
      appBar:
      AppBar(
        title: Text("Namaste Thailand"),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await ref.refresh(fetchCities);
              await ref.refresh(advertisement);
              print('done');
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    SizedBox(
                        height: 158,
                        width: double.infinity,
                        child:
                        Consumer(
                          builder: (context, watch, _) {
                            final citiesFuture = watch.watch(fetchCities);

                            return citiesFuture.when(
                              data: (response) {
                                if(response==null){
                                  return Container( child: const Center(child: Text("Unable to communicate with server"),),);
                                }
                                else if(response.data['status']=="true")
                                  {
                                    cityList.clear();
                                    for(var item in response.data['cities']){
                                      cityList.add(item);
                                    }

                                    return SizedBox(
                                      // Your desired size for the container
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: cityList.length,
                                        itemBuilder: (context, index) {


                                          return cityInfo(imagePath: cityList[index]["image"], place: cityList[index]['cityname'],
                                              onTab:() {
                                            Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (
                                                          context) =>  CityInformation(id: cityList[index]['id'].toString(), cityName: cityList[index]["cityname"].toString(),))
                                              );});




                                        },
                                      ),
                                    );
                                  }
                                else if(response.data["status"]=="false"){
                                  return Container(child: const Center(child: Text("No data is found"),),);
                                }
                                else{
                                  return Container(child: Center(child: Text(response.toString()),),);
                                }



                              },
                              loading: () => Center(child: Container(
                                  height: 50,
                                  width: 50,
                                  child: const CircularProgressIndicator())),
                              error: (error, _) => Text('Error: $error'),
                            );
                          },
                        )



                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Welcome to Thailand",
                      style: GoogleFonts.ptSerif(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.blueGrey,
                          letterSpacing: 2),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: 50,
                      child:

                      ListView(
                        scrollDirection: Axis.horizontal,

                        shrinkWrap: true,

                          children: [

                            const SizedBox(
                              width: 5,
                            ),
                            Center(
                              child: Row(
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.thermometer,
                                    size: 17,
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Consumer(
                                    builder: (context, watch, _) {
                                      final countryFuture = watch.watch(aboutCountry);

                                      return countryFuture.when(
                                        data: (response) {
                                          if (response==null){
                                            return const Text("unable to communicate");
                                          }



                                          final countryWeather = response['weather']['temperature'].toString();
                                          // EasyLoading.show(status: countryWeather, dismissOnTap: true);

                                          return SizedBox(
                                            // Your desired size for the container
                                              child: Text("$countryWeather\u00b0 C")
                                          );
                                        },
                                        loading: () => Center(child: Container(
                                            height: 50,
                                            width: 50,
                                            child: const Center(child: Text("load...")),
                                        )),
                                        error: (error, _) => Text('Error: $error'),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),


                            const SizedBox(
                              width: 15,
                            ),


                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text("Currency", style: TextStyle(color: Colors.blueGrey,
                                    fontWeight: FontWeight.w400),),
                                const SizedBox(height: 8,),
                                Row(
                                  children: [
                                    Text(
                                      inr != null ? inr.toString() : "loading",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 2,),
                                    Text(
                                      "INR",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      thb != null ? thb.toString() : "loading",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      "THB",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // timing india or thai
                            SizedBox(
                              width: 20,
                            ),
                            DualClockWidget(),
                            // Text(indianTime, style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w500, ),),
                            // SizedBox(width: 2,),
                            // // Text("IST", style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w400, ),),
                            // SizedBox(width: 5,),
                            // Text(thailandTime, style: GoogleFonts.poppins(color: Colors.grey[600], fontWeight: FontWeight.w500, ),),
                            // SizedBox(width: 2,),
                            // Text("ICT", style: GoogleFonts.poppins(color: Colors.grey[600], fontWeight: FontWeight.w400, ),),
                          ],

                      ),
                    ),
                    SizedBox(
                        height: 210,
                        width: double.infinity,
                        child:
                        Consumer(
                          builder: (context, watch, _) {
                            final citiesFuture = watch.watch(advertisement);

                            return citiesFuture.when(
                              data: (response) {

                                print('-------${response}');
                                 if(response==null){
                                   return Container(child: const Center(child: Text("Unable to communicate server"),),);
                                 }
                               else if(response.data["status"]=="201"){
                                 advertisementList.clear();
                                 for(var items in response.data["advert"]){
                                   advertisementList.add(items);
                                 }
                                   return SizedBox(
                                     child: ListView.builder(
                                       scrollDirection: Axis.horizontal,
                                       itemCount: advertisementList.length,
                                       itemBuilder: (context, index) {

                                         return getAdvertisement(imagePath: advertisementList[index]['image'], place: advertisementList[index]['name']);
                                       },
                                     ),
                                   );
                                 }

                                else {
                                  return Container(child: Center(child: Text(response.toString())));
                                }
                              },
                              loading: () => Center(
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              error: (error, _) => Text('Error: $error'),
                            );
                          },
                        )


                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlurryContainer(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        width: double.infinity,
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(10),
                        elevation: 1,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "About Thailand ",
                              style: GoogleFonts.notoSansAnatolianHieroglyphs(
                                  color: Colors.white,
                                  fontSize: 20,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text("Thailand",style: TextStyle(fontWeight: FontWeight.bold),),
                    Consumer(
                      builder: (context, watch, _) {
                        final countryFuture = watch.watch(aboutCountry);

                        return countryFuture.when(
                          data: (response) {
                            final countryDescription = response['main']['description'].toString();

                            return SizedBox(
                              // Your desired size for the container
                              child:
                              Html(
                                data: countryDescription.toString(),
                              ),
                            );
                          },
                          loading: () => Center(child: Container(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator())),
                          error: (error, _) => Text('Error: $error'),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 300,
                        aspectRatio: 16 / 9,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        viewportFraction: 0.8,
                      ),
                      items: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/newThai1.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/newThai2.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/newThai3.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlurryContainer(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        width: double.infinity,
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(10),
                        elevation: 1,
                        child: Row(children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Culture ",
                            style: GoogleFonts.notoSansAnatolianHieroglyphs(
                                color: Colors.white,
                                fontSize: 20,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w400),
                          ),
                        ])),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.25,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.5,
                          child: Image.asset("assets/images/culture1.jpg",
                              fit: BoxFit.fill),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Phi Ta Khon",
                              style: GoogleFonts.robotoSlab(
                                  color: Colors.black, fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text("The Ghost Festival",
                                style: GoogleFonts.libreBaskerville(
                                    letterSpacing: 1, color: Colors.blueGrey))
                          ],
                        ),
                      ],
                    ),
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: '- Also known as the Ghost Festival or the Festival of Ghosts\n'),
                          TextSpan(
                              text: '- An annual Buddhist festival held in the Dan Sai district of Loei province, northeastern Thailand\n'),
                          TextSpan(
                              text: '- Celebrated during the first week of July\n'),
                          TextSpan(
                              text: '- Participants wear elaborate masks made of carved coconut-tree trunks and colorful costumes made of bright cloth\n'),
                          TextSpan(
                              text: '- The festival features parades, traditional music and dance, and a playful atmosphere\n'),
                          TextSpan(
                              text: '- The masks and costumes are inspired by local folklore and are meant to represent ghosts or spirits\n'),
                          TextSpan(
                              text: '- The festival is believed to have originated from a local legend involving the return of Buddha from heaven\n'),
                          TextSpan(
                              text: '- The festival is seen as a way to pay homage to local spirits and ancestors and to ensure a good harvest\n'),
                          TextSpan(
                              text: '- The festival is a popular tourist attraction and is recognized as an intangible cultural heritage by UNESCO\n'),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              "Songkran Festival",
                              style: GoogleFonts.robotoSlab(
                                  color: Colors.black, fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text("Water Festival",
                                style: GoogleFonts.libreBaskerville(
                                    letterSpacing: 1, color: Colors.blueGrey))
                          ],
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.25,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.5,
                            child:
                            Image.asset("assets/images/wt.PNG", fit: BoxFit.fill))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: '- Also known as the Thai New Year\n'),
                          TextSpan(text: '- Celebrated annually from April 13-15\n'),
                          TextSpan(
                              text: '- The festival marks the end of the dry season and the beginning of the rainy season\n'),
                          TextSpan(
                              text: '- Participants engage in a water fight using water guns, buckets, and hoses\n'),
                          TextSpan(
                              text: '- The water symbolizes purification and the washing away of sins and bad luck\n'),
                          TextSpan(
                              text: '- Many Thai people visit temples during the festival to offer food to the monks and participate in traditional ceremonies\n'),
                          TextSpan(
                              text: '- The festival is a time for family reunions and showing respect to elders\n'),
                          TextSpan(
                              text: '- The festival is also celebrated in other countries, such as Laos and Myanmar\n'),
                          TextSpan(
                              text: '- The festival is a major tourist attraction and draws visitors from around the world\n'),
                          TextSpan(
                              text: '- The festival is also known for its parties, particularly in tourist destinations such as Bangkok and Phuket\n'),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.25,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.5,
                          child: Image.asset("assets/images/culture2.jpg",
                              fit: BoxFit.fill),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Boon Bang Fai",
                              style: GoogleFonts.robotoSlab(
                                  color: Colors.black, fontWeight: FontWeight.w900),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text("Rocket Festival",
                                style: GoogleFonts.libreBaskerville(
                                    letterSpacing: 1, color: Colors.blueGrey))
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: '- Also known as the Rocket Festival\n'),
                          TextSpan(
                              text: '- Celebrated in May each year in the northeastern region of Thailand\n'),
                          TextSpan(
                              text: '- The festival is meant to bring good luck and encourage the coming of the rainy season\n'),
                          TextSpan(
                              text: '- Participants construct homemade rockets and launch them into the sky\n'),
                          TextSpan(
                              text: '- The rockets are often decorated with colorful designs and carry offerings to the gods\n'),
                          TextSpan(
                              text: '- The festival also features parades, traditional music and dance, and a playful atmosphere\n'),
                          TextSpan(
                              text: '- The rockets are judged for their height, speed, and decoration\n'),
                          TextSpan(
                              text: '- The festival has its roots in ancient fertility rituals and is believed to have originated in Laos\n'),
                          TextSpan(
                              text: '- The festival is a way to celebrate local traditions and culture\n'),
                          TextSpan(
                              text: '- The festival is a popular tourist attraction and is recognized as an intangible cultural heritage by UNESCO\n'),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 5,
                    ),
                    BlurryContainer(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        width: double.infinity,
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(10),
                        elevation: 1,
                        child: Row(children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "National Monuments",
                            style: GoogleFonts.notoSansAnatolianHieroglyphs(
                                color: Colors.white,
                                fontSize: 20,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w400),
                          ),
                        ])),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.4,
                      width: double.infinity,
                      child: Image.asset("assets/images/budha.jpg", fit: BoxFit.fill),
                    ),
                    Text(
                      "Big Buddha",
                      style: GoogleFonts.robotoSlab(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 20),
                    ),
                    SizedBox(height: 5,),
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: '- Also known as the Phra Buddha Maha Nawamin\n'),
                          TextSpan(
                              text: '- Located in the province of Ang Thong, north of Bangkok\n'),
                          TextSpan(
                              text: '- Features a giant Buddha statue made of gold and bronze\n'),
                          TextSpan(
                              text: '- The statue is 92 meters tall, making it one of the largest Buddha statues in the world\n'),
                          TextSpan(
                              text: '- The statue sits on a pedestal that is 15 meters high, making the total height of the monument 107 meters\n'),
                          TextSpan(
                              text: '- The statue was completed in 2008 after 18 years of construction\n'),
                          TextSpan(
                              text: '- The monument is a popular tourist attraction and a symbol of Thai Buddhism\n'),
                          TextSpan(
                              text: '- Visitors can climb stairs to reach the base of the statue and enjoy panoramic views of the surrounding area\n'),
                          TextSpan(
                              text: '- The monument is also home to a museum showcasing Buddhist art and history\n'),
                          TextSpan(
                              text: '- The monument is a testament to the craftsmanship and dedication of the Thai people\n'),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.4,
                      width: double.infinity,
                      child:
                      Image.asset("assets/images/monument.jpg", fit: BoxFit.fill),
                    ),
                    Text(
                      "The Sanctuary Of Truth",
                      style: GoogleFonts.robotoSlab(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 20),
                    ),
                    SizedBox(height: 5,),
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: 'The Sanctuary of Truth\n',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: '- A wooden temple and museum located in Pattaya, Thailand\n'),
                          TextSpan(
                              text: '- Constructed entirely of teak wood, the temple is a stunning example of traditional Thai architecture\n'),
                          TextSpan(
                              text: '- The temple was started in 1981 and is still under construction today\n'),
                          TextSpan(
                              text: '- The temple is dedicated to traditional Thai religious and philosophical beliefs\n'),
                          TextSpan(
                              text: '- The temple features intricate carvings and sculptures depicting mythological figures and scenes from Buddhist and Hindu mythology\n'),
                          TextSpan(
                              text: '- The temple is a symbol of the traditional Thai culture and a reminder of the importance of art in everyday life\n'),
                          TextSpan(
                              text: '- The temple is open to visitors and offers guided tours and cultural performances\n'),
                          TextSpan(
                              text: '- The temple is a popular tourist attraction in Pattaya and a unique cultural experience\n'),
                          TextSpan(
                              text: '- The temple is a tribute to the beauty and grandeur of Thai architecture and craftsmanship\n'),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.zero,
                      color: Colors.red,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.4,
                      width: double.infinity,
                      child: Image.asset("assets/images/monument3.PNG",
                          fit: BoxFit.fill),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      "Phuket Heroines Monument",
                      style: GoogleFonts.robotoSlab(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 20),
                    ),
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: 'Phuket Heroines Monument\n',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: '- A statue monument located in Phuket, Thailand\n'),
                          TextSpan(
                              text: '- Commemorates two sisters who led the local people in defending the island against a Burmese invasion in the 18th century\n'),
                          TextSpan(
                              text: '- The sisters, Thao Thep Krasattri and Thao Sri Sunthon, are regarded as heroines in Thai history\n'),
                          TextSpan(
                              text: '- The monument was built in 1967 and is a popular tourist attraction\n'),
                          TextSpan(
                              text: '- The monument is made of brass and stands at 2.75 meters tall\n'),
                          TextSpan(
                              text: '- The statue features the sisters standing back to back, holding a sword and a baby, respectively\n'),
                          TextSpan(
                              text: '- The monument serves as a reminder of the bravery and sacrifice of the local people in defending their homeland\n'),
                          TextSpan(
                              text: '- The monument is a symbol of pride and unity for the people of Phuket\n'),
                        ],
                      ),
                    )


                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
Widget cityInfo({ required  String imagePath, required  String place, required VoidCallback onTab} )
{
    return    Column(
        children:[ InkWell(
          onTap: onTab,
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
                        child: Image.network(imagePath,
                          fit: BoxFit.fill,
                          width: 178,
                          height: 120,

                        ),
                      ),
                      SizedBox(height: 2,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(place, style: GoogleFonts.merriweather(color: Colors.orangeAccent.withOpacity(0.9), fontWeight: FontWeight.w800, fontSize: 18),),
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
Widget getAdvertisement({required String imagePath, required String place}){
    return   Padding(
     padding: const EdgeInsets.symmetric(horizontal: 2),
     child: Card(

         color: Colors.grey[200],
         shape: RoundedRectangleBorder(

           borderRadius: BorderRadius.circular(5.0), //<-- SEE HERE
         ),
         margin: EdgeInsets.all(2),
         child:
         Container(
           width: 230,

           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               ClipRRect(
                 borderRadius: BorderRadius.circular(5.0),
                 child: Image.network(imagePath,
                   fit: BoxFit.fill,
                   width: 230,
                   height: 150,

                 ),
               ),
               SizedBox(height: 5,),
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Text(place, style: GoogleFonts.merriweather(color: Colors.red.withOpacity(0.9), fontWeight: FontWeight.w800, fontSize: 18),),
                 ],
               ),
               SizedBox(height: 5,)
             ],

           ),
         )

     ),
          );
}
  Widget drawer() {
    return Drawer(
      elevation: 2,
      shadowColor: Colors.white,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(

            child: Column(

              children: [
                ClipOval(
                    child:
                    AppPreferences.getUserProfile() != "" && AppPreferences
                        .getUserProfile()
                        .isNotEmpty
                        ?
                    Image.network(
                      AppPreferences.getUserProfile(), height: 70, width: 70,)
                        :
                    Image.asset(
                      "assets/icons/user.png", height: 70, width: 70,)
                ),
                AppPreferences.getUserDisplayName()!=""?
                Text(
                  AppPreferences.getUserDisplayName(),
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontSize: 17, letterSpacing: 2),
                ):SizedBox(),
                AppPreferences.getUserEnail()!=""?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                    Flexible(
                      child: Text(
                          AppPreferences.getUserEnail()!,
                          style: GoogleFonts.poppins(
                             color: Colors.white, fontSize: 12, letterSpacing: 2),
                        ),
                    ),

                    SizedBox(height: 10,)
                  ],
                ):SizedBox()
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
              color: Colors.blueGrey,
            ),
            title: Text(
              'Home',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  Dashboard()

                ),
              );


            },
          ),
          AppPreferences.getUserId()!=""?
          ListTile(
            leading: const Icon(Icons.person, color: Colors.blueGrey),
            title: Text("Profile", style: GoogleFonts.poppins()),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const UserProfile()));
            },
          ):SizedBox(),
/*
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.blueGrey),
            title: Text(
              'Thai Calender',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ThaiCalender()));
            },
          ),
*/
          ListTile(
            leading: const Icon(Icons.speaker, color: Colors.blueGrey),
            title: Text(
              'Translator',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LanguageTranslator()));
            },
          ),
          AppPreferences.getUserId()!=""?
          ListTile(
            leading: const Icon(Icons.contact_page, color: Colors.blueGrey),
            title: Text(
              'Contact Us',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactUs()),
              );
            },
          ):SizedBox(),
          ListTile(
            leading: const Icon(Icons.shop, color: Colors.blueGrey),
            title: Text(
              'Add shop',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              if(AppPreferences.getUserId()!=""){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddShop()),
                );
              }
              else{
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );

              }

            },
          ),
          ListTile(
            leading: const Icon(Icons.help, color: Colors.blueGrey),
            title: Text(
              'Help Us',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpUs()),
              );
            },
          ),
          AppPreferences.getUserId()!=""?
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.blueGrey),
            title: Text(
              'Logout',
              style: GoogleFonts.poppins(),
            ),
            onTap: ()
            async {
              await AuthLogout().logout();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),(route) => false,
                );
              }
            },
          ):ListTile(
            leading: const Icon(Icons.login, color: Colors.blueGrey),
            title: Text(
              'Login',
              style: GoogleFonts.poppins(),
            ),
            onTap: ()
             {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
            },
          ),
          AppPreferences.getUserId()!=""?
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.blueGrey),
            title: Text(
              'Delete Account',
              style: GoogleFonts.poppins(),
            ),
            onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DeleteAccount()),
                );
            },
          ):SizedBox(),


        ],
      ),
    );

  }



  Future<void> fetchCurrencyData() async {
    Dio dio = Dio();
    String url = 'https://test.pearl-developer.com/thaitours/public/api/get-currency'; // Replace with your actual API endpoint

    try {
      Response response = await dio.get(
        url,
        options: Options(headers: {
          'Authorization': 'Bearer ${AppPreferences.getUserId()}'
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          inr = response.data["currency"]["indiancurrency"];
          thb = response.data["currency"]["thailandcurrency"];
        });
      }else{
        setState(() {
          inr = '1';
          thb = '0.41';
        });
      }
    } catch (e) {
      setState(() {
        inr = '1';
        thb = '0.41';
      });
    }
  }

  final advertisement = FutureProvider((ref) async {
    final dio = Dio();
    dio.options.headers['Authorization'] =
    'Bearer ${AppPreferences.getUserId()}';

    try {
      final response = await dio.get(
          'https://test.pearl-developer.com/thaitours/public/api/get-advertisements');
      print(
          "#################################################################################categoryResponse${response.data}");

      return response;
    } on DioError catch (e) {

      return e.response;
    }
  });


  showDialogBox() =>
      showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) =>
            CupertinoAlertDialog(
              title: const Text('No Connection'),
              content: const Text('Please check your internet connectivity'),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context, 'Cancel');
                    setState(() => isAlertSet = false);
                    isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                    if (!isDeviceConnected && isAlertSet == false) {
                      showDialogBox();
                      setState(() => isAlertSet = true);
                    }
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
      );
  final aboutCountry = FutureProvider((ref) async {
    final dio = Dio();
    dio.options.headers['Authorization'] =
    'Bearer ${AppPreferences.getUserId()}';

    try {
      final response = await dio.get(
          'https://test.pearl-developer.com/thaitours/public/api/about-country');
      print(
          "#################################################################################categoryResponse${response.data}");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  });

}


