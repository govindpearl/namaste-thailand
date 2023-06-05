import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:namastethailand/Dashboard/dashboard.dart';

import '../Dashboard/ApiButtons/apiButtonContentList.dart';
import '../Utility/sharePrefrences.dart';


final cityCategory = FutureProvider.family((ref,String id) async {
  final dio = Dio();
  dio.options.headers['Authorization'] = 'Bearer ${AppPreferences.getUserId()}';

  try {
    final response = await dio.post(
      'https://test.pearl-developer.com/thaitours/public/api/get-categories',
      data: {'id': int.parse(id)}, // Replace `yourId` with the actual id value you want to send
    );

    return response;
  } on DioError catch (e) {
    return e.response;
  }
});
final cityWeather = FutureProvider.family((ref,String id) async {
  final dio = Dio();
  dio.options.headers['Authorization'] = 'Bearer 280|oXV7rCWxPHBsGCGrC3cOrEfUyXEcZ3v3ZTqLvtJa';

  try {
    final response = await dio.post(
      'https://test.pearl-developer.com/thaitours/public/api/get-weather',
      data: {'city_id': id}, // Replace `yourId` with the actual id value you want to send
    );
    print("321#############WeatherResponse${response} \n Id : $id");

    return response;
  } on DioError catch (e) {

    return e.response;
  }
});
final cityContent = FutureProvider.family((ref,String id) async {
  final dio = Dio();
  dio.options.headers['Authorization'] = 'Bearer ${AppPreferences.getUserId()}';

  try {
    final response = await dio.post(
      'https://test.pearl-developer.com/thaitours/public/api/about-city?city_id=${id}',
      data: {'city_id': id}, // Replace `yourId` with the actual id value you want to send
    );

    return response;
  } on DioError catch (e) {
    return e.response;
  }
});


class CityInformation extends StatefulWidget {
  final String id;
  final String cityName;
  const CityInformation({Key? key,required this.id, required this.cityName}) : super(key: key);

  @override
  State<CityInformation> createState() => _CityInformationState();

}


class _CityInformationState extends State<CityInformation> {

  GoogleMapController? mapController;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 0,
  );
  bool getCat = false;
  bool getWeather = false;
  bool aboutCity = false;
  bool showScreen = false;
  void secondScreen() {
    print("id----------------id--${widget.id}");
    print('cat ${getCat.toString()}\nweather ${getWeather.toString()}\ncity ${aboutCity.toString()}');
    if (getCat==true && getWeather==true && aboutCity==true) {
      setState(() {
        showScreen = true;
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return showScreen
        ? Scaffold(body: SafeArea(child: Container(

                 width: double.infinity,
                 height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/icons/placeholder.png", height: 200,width: 200,),
          SizedBox(height: 5,),
          Text("No data found!"),
          SizedBox(height: 20,),
          ElevatedButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  Dashboard()

              ),
            );


          }, child: Text("Go back home"))



        ],
      ),

    )),)
        :Scaffold(
        backgroundColor: Colors.grey[300],

        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "${widget.cityName[0].toUpperCase()}${widget.cityName.substring(1).toLowerCase()}",style: TextStyle(color: Colors.white),
          ),        iconTheme: IconThemeData(color: Colors.blueGrey),


          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 12.0,
                  ),
                  SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child:
                      Consumer(
                        builder: (context, watch, _) {
                          print('IDDD ${widget.id}');
                          final citiesFuture = watch.watch(cityCategory(widget.id));

                          return citiesFuture.when(
                            data: (response) {
/*
                        EasyLoading.show(status: response['categories'].toString(), dismissOnTap: true);
*/                          if(response==null){

                                return Container(child: Center(child: Text("Unable to communicate"),),);
                              }
                              else if(response.data["status"]=='true'){
                                final cities = response.data['categories'];
                                return SizedBox(
                                  // Your desired size for the container
                                    child:
                                    ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: cities.length,
                                      itemBuilder: (context, index) {
                                        final city = cities[index];

                                        return
                                          Padding(
                                            padding: EdgeInsets.only(right: 8),
                                            child: InkWell(
                                              onTap: (){
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) =>  ApiButtonContent(city_name: widget.cityName!.toString(),
                                                    city_id: widget.id.toString(),
                                                    category_id: city["category_id"].toString(), categoryname: city['name'].toString(),)

                                                  ),
                                                );
                                              },
                                              child: Container(
                                                height: 50,
                                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.orangeAccent,
                                                    ),
                                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                                ),
                                                child: Center(child: Text(city["name"],style: GoogleFonts.roboto(color:Colors.blueGrey, letterSpacing: 2, fontSize: 17),)),

                                              ),
                                            ),
                                          );
                                        /*ListTile(
                                title: Text(city['cityname']),
                                // Add other widgets to display additional information about the city, such as the image
                              );*/
                                      },
                                    )
                                );

                              }

                              else if(response.data['status'] == "false" ){
                                getCat=true;
                                WidgetsBinding.instance!.addPostFrameCallback((_) {
                                  secondScreen();
                                });                                print("boolean------1 getCat$getCat");
                                print("--cate---first time ${showScreen}");
                                return Container(child: Center(child: Text("No data is found"),),);
                              }else{
                                return Container(child: Center(child: Text(response.toString())),);
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
                  SizedBox(
                    height: 10,
                  ),
                  Text("Welcome to ${widget.cityName} ", style: GoogleFonts.ptSerif(
                      fontSize: 20, fontWeight: FontWeight.w400,
                      color: Colors.blueGrey,
                      letterSpacing: 2
                  ),),
                  SizedBox(height: 10,),

                  SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: Consumer(
                        builder: (context, watch, _) {
                          final citiesFuture = watch.watch(cityWeather(widget.id));

                          return citiesFuture.when(
                            data: (response) {
                              if(response== null){
                                return Text("no data is found");
                              }
                              else if(response.data['status']=='true'){
                                final weather = response;
                                String conditionName = '';
                                IconData conditionIcon = Icons.error; // Default icon for unhandled conditions
                                switch (weather.data['condition']) {
                                  case 1:
                                    conditionName = 'Tornado';
                                    conditionIcon = Icons.tornado;
                                    break;
                                  case 2:
                                    conditionName = 'Tropical Cyclone';
                                    conditionIcon = Icons.cached; // Replace with the appropriate icon
                                    break;
                                  case 3:
                                    conditionName = 'Blizzard';
                                    conditionIcon = Icons.ac_unit; // Replace with the appropriate icon
                                    break;
                                  case 4:
                                    conditionName = 'Drought';
                                    conditionIcon = Icons.grain; // Replace with the appropriate icon
                                    break;
                                  case 5:
                                    conditionName = 'Winter Storm';
                                    conditionIcon = Icons.ac_unit; // Replace with the appropriate icon
                                    break;
                                  case 6:
                                    conditionName = 'Winter Storm';
                                    conditionIcon = Icons.ac_unit; // Replace with the appropriate icon
                                    break;
                                  case 7:
                                    conditionName = 'Heat Wave';
                                    conditionIcon = Icons.whatshot; // Replace with the appropriate icon
                                    break;
                                  case 8:
                                    conditionName = 'Rain';
                                    conditionIcon = Icons.beach_access; // Replace with the appropriate icon
                                    break;
                                  case 9:
                                    conditionName = 'Wind';
                                    conditionIcon = Icons.air; // Replace with the appropriate icon
                                    break;
                                  case 10:
                                    conditionName = 'Cloud';
                                    conditionIcon = Icons.cloud; // Replace with the appropriate icon
                                    break;
                                  case 11:
                                    conditionName = 'Humidity';
                                    conditionIcon = Icons.opacity; // Replace with the appropriate icon
                                    break;
                                  case 12:
                                    conditionName = 'Precipitation';
                                    conditionIcon = Icons.waves; // Replace with the appropriate icon
                                    break;
                                  case 13:
                                    conditionName = 'Snow';
                                    conditionIcon = Icons.ac_unit; // Replace with the appropriate icon
                                    break;
                                  default:
                                  // Handle any other condition values if needed
                                    break;
                                }

                                return SizedBox(
                                  // Your desired size for the container
                                    child: Row(
                                      children: [
                                        SizedBox(width: 5,),
                                        Text("${weather.data["weather"]}\u00b0 C",style: TextStyle(color:Colors.red, letterSpacing: 2, fontSize: 17),),
                                        SizedBox(width: 10,),
                                        Text(conditionName),
                                        SizedBox(width: 10,),
                                        Icon(conditionIcon),                            ],
                                    )


                                );
                              }
                              else if(response.data['status'] == "false"){
                                getWeather = true;
                                WidgetsBinding.instance!.addPostFrameCallback((_) {
                                  secondScreen();
                                });                                print("boolean------2 getWeather$getWeather");
                                print("--cate---second time ${showScreen}");
                                return Container(
                                    height: 100.0,
                                    child: Center(child: Text(response.data['msg']),));

                              }else{
                                return Container(
                                  height: 100.0,
                                  child: Center(child: Text('No Data Available'),),
                                );
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
                  SizedBox(height: 10,),

                  BlurryContainer(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      width: double.infinity,
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(10),
                      elevation: 1,
                      child: Row(
                        children: [
                          SizedBox(width: 10,),
                          Text("About ${widget.cityName} ",
                            style: GoogleFonts.notoSansAnatolianHieroglyphs(
                                color: Colors.white,
                                fontSize: 20,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w400),),

                        ],


                      )),

                  SizedBox(height: 5,),
                  Consumer(
                    builder: (context, watch, _) {
                      final citiesFuture = watch.watch(cityContent(widget.id));

                      return citiesFuture.when(
                        data: (response) {

                          if(response == null){

                            return Container(
                              child: Center(child: Text('Unable to communicate to server'),),
                            );
                          }else if(response.data['status'] == 'true'){
                            print('Done');
                            final description = response.data['contents']['description'];
                            final LatLng latLng = LatLng(
                              double.parse(response.data['contents']['latitude']),
                              double.parse(response.data['contents']['longitude']),
                            );
                            return Column(
                              children: [
                                SizedBox(
                                    child:
                                    Row(
                                      children: [
                                        Flexible(child: Html(data: description)),

                                      ],
                                    )
                                ),
                                SizedBox(height: 10,),

                                CarouselSlider(
                                  options: CarouselOptions(
                                    height: 300,
                                    aspectRatio: 16/9,
                                    enlargeCenterPage: true,
                                    autoPlay: true,
                                    viewportFraction: 0.8,
                                  ),
                                  items: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: AssetImage('assets/images/newThai1.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: AssetImage('assets/images/bangkok2.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: AssetImage('assets/images/bangkok3.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: AssetImage('assets/images/bangkok4.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: AssetImage('assets/images/bangkok5.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,),

                                SizedBox(
                                  height: 200,
                                  child:
                                  GoogleMap(
                                    mapType: MapType.normal,
                                    initialCameraPosition: _kGooglePlex,
                                    compassEnabled: true,
                                    onMapCreated: (GoogleMapController controller) {
                                      setState(() {
                                        mapController = controller;
                                        mapController?.animateCamera(
                                            CameraUpdate.newCameraPosition(
                                                CameraPosition(target: latLng, zoom: 12)
                                              //17 is new zoom level
                                            )
                                        );
                                      });
                                    },
                                    markers: {
                                      Marker(
                                        markerId: const MarkerId("marker"),
                                        position: latLng,
                                      ),
                                    },

                                  ),
                                )
                              ],
                            );
                          }else if(response.data['status'] == 'false'){
                            aboutCity= true;
                            WidgetsBinding.instance!.addPostFrameCallback((_) {
                              secondScreen();
                            });                            print("boolean------3 aboutCity$aboutCity");
                            print("--cate---third time ${showScreen}");
                            return
                              Container(
                                height: MediaQuery.sizeOf(context).height*0.4,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(child: Image.asset("assets/icons/placeholder.png", width: 100, height: 100,)),
                                    Center(child: Text(response.data['msg'])),
                                  ],
                                ),
                              );
                          }else {
                            return Container(
                              child: Center(child: Text(response.toString()),),
                            );
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
                  ),
                ]
            ),
          ),
        )
    );

  }
}
// amitnewmac branch
