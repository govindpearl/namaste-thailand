import 'dart:convert';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:namastethailand/Dashboard/ApiButtons/welcomeApiButton.dart';

import '../../Utility/sharePrefrences.dart';
import 'ListCardforApiButton.dart';

class ApiButtonContent extends StatefulWidget {
  final String city_name;
  final String city_id;
  final String category_id;
  final String categoryname;



  ApiButtonContent({
    Key? key,
    required this.city_name,
    required this.city_id,
    required this.category_id,
    required this.categoryname,
  }) : super(key: key);

  @override
  State<ApiButtonContent> createState() => _ApiButtonContentState();
}


class _ApiButtonContentState extends State<ApiButtonContent> {
  List<Map<String,dynamic>> contentList = [];

  @override
  Widget build(BuildContext context) {
    final categorydata = CategoryData(
      widget.city_id ,
      widget.category_id,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text(widget.categoryname.toUpperCase()),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              BlurryContainer(
                width: double.infinity,
                color: Colors.grey.shade200,
                height: 50,
                elevation: 1,
                borderRadius: BorderRadius.circular(10),
                child:Text(
                  "  ${widget.categoryname} in ${widget.city_name}".toUpperCase(),
                  style: GoogleFonts.ptSerif(
                    color: Colors.blueGrey,
                    fontSize: 20,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),

              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final citiesFuture = ref.watch(cityCategoryContent(categorydata));

                    return citiesFuture.when(
                      data: (response) {
                        if(response== null){
                          return Container(child: Center(child: Text("Unable to communicate"),),);
                        }
                        else if (response.data['status'] == 'true') {
                          contentList.clear();
                          for(var item in response.data['categories']){
                            contentList.add(item);
                          }
                          //EasyLoading.showToast(content[0]['name'].toString());
                          return ListView.builder(
                            //scrollDirection: Axis.horizontal,
                            itemCount: contentList.length,
                            itemBuilder: (context, index) {

                              final category = contentList[index];
                              return
                              ButtonPlaceCard(
                              place: category['title'] .toString(),
                              imagePath: "assets/images/spa3.jpg",
                              onTab: () {
                               Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  WelcomeApiButton(
                                  id: category['id'].toString(),
                                )
                                ),
                              );
                              },
                            )

/*
                                getCatListitem(imagePath: "assets/images/spa3.jpg", place: "abc" .toString(), onTap: (){

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  WelcomeApiButton(
                                    id: category['id'].toString(),
                                  )
                                  ),
                                );
                              })
*/



                              ;
                            },
                          );

                        }
                        else if (response.data==['false']){
                          return Container(child: Center(child: Text(response.data['msg']),),);
                        }
                        else{
                          return Text(response.toString());
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
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget getCatListitem({required String imagePath, required String place, required VoidCallback onTap}){
    return   Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: GestureDetector(
        onTap:onTap ,
        child: Card(

            color: Colors.grey[200],
            shape: RoundedRectangleBorder(

              borderRadius: BorderRadius.circular(5.0), //<-- SEE HERE
            ),
            margin: EdgeInsets.all(2),
            child:
            Container(
              width: double.infinity,
              height: 180,
              color: Colors.grey.withOpacity(0.5),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Container(
                      height:180 ,
                      width: 180,
                      child: Image.asset(imagePath,
                        fit: BoxFit.fill,

                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Center(child: Text(place, style: GoogleFonts.merriweather(color: Colors.black.withOpacity(0.9), fontWeight: FontWeight.w800, fontSize: 18),)),
                  SizedBox(height: 5,)
                ],

              ),
            )

        ),
      ),
    );
  }

}


final cityCategoryContent = FutureProvider.family((ref, CategoryData data) async {
  final dio = Dio();
  dio.options.headers['Authorization'] = 'Bearer ${AppPreferences.getUserId()}';

  try {
    final response = await dio.post(
      'https://test.pearl-developer.com/thaitours/public/api/get-category-content',
      data: {
        'city_id': int.parse(data.id),
        'cat_id': int.parse(data.catId),
      },
    );
    return response;
  }on DioError catch (e) {
    return e.response;
  }
});

class CategoryData {
  final String id;
  final String catId;

  CategoryData(this.id, this.catId);
}
