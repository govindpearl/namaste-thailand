import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:namastethailand/AddShop/registerShopStatus.dart';

import '../widget/api_services.dart';

class AddShop extends StatefulWidget {
  const AddShop({Key? key}) : super(key: key);

  @override
  State<AddShop> createState() => _AddShopState();
}

class _AddShopState extends State<AddShop> {

  TextEditingController _shopNameController = TextEditingController(text: '');
  TextEditingController _shopTypeController = TextEditingController(text: '');
  TextEditingController _placeController = TextEditingController(text: '');
  Map<String,dynamic> cities = Map();
  List<String> cityName=[];
  String? selectedValue;

  Future getCities() async {

    Response? response = await Api.getCities();

    if(response == null){
      EasyLoading.showToast('Unable to load cities');
    }else if(response.data['status'] == 'true') {
      for(var item in response.data['cities']){
        cities[item['cityname']] = item['id'];
      }
      print(cities.keys.toList());
      cities.forEach((key, value) {
        cityName.add(key);
      });
      print(cityName.toString());
      setState(() {

      });
    }else if(response.data['status'] == 'false') {
      EasyLoading.showToast('Error code: ${response}');
    }else{
      EasyLoading.showToast(response.toString());
    }
  }
  @override
  void initState() {
    getCities();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Shop"),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
      ),
      body: Container(

          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage("assets/images/blurBackground.jpg"),
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode.dstATop,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Center(
              child: BlurryContainer(
                elevation: 10,
                color: Colors.white.withOpacity(0.5),
                width: MediaQuery.of(context).size.width*0.8,
                height:MediaQuery.of(context).size.height*0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Register your Shop in", style: GoogleFonts.poppins(color:Colors.black, fontSize: 17, fontWeight: FontWeight.w500),),
                    SizedBox(height: 5,),
                    Text("Namaste Thailand", style: GoogleFonts.playfairDisplay(wordSpacing: 1, color: Colors.orangeAccent, fontWeight: FontWeight.w800, fontSize: 22)),
                    SizedBox(height: 10,),
                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade200,
                          border: Border.all(
                              width: 2, color: Color(0xFF000080)
                          )
                      ),
                      child: TextFormField(
                        controller: _shopNameController,
                        decoration: InputDecoration(
                          hintText: 'Shop name',
                          prefixIcon: Icon(Icons.shop),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        ),
                        style: TextStyle(fontSize: 16),
                      ),

                    ),
                    SizedBox(height: 10,),
                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade200,
                          border: Border.all(
                              width: 2, color: Color(0xFF000080)
                          )
                      ),
                      child: TextFormField(
                        controller: _shopTypeController,
                        decoration: InputDecoration(
                          hintText: 'Shop type',
                          prefixIcon: Icon(Icons.type_specimen),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        ),
                        style: TextStyle(fontSize: 16),
                      ),

                    ),
                    SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.only(left: 8.0),
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade200,
                          border: Border.all(
                              width: 2, color: Color(0xFF000080)
                          )
                      ),
                      child: cityName.isNotEmpty?
                      DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          hint: Text('Select your City',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: cities.keys.toList().map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          )).toList(),
                            value: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as String;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            height: 40,
                            width: 140,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                          ),
                        ),
                      ) :
                          Center(child: Text('Loading cities')),

                    ),
                    SizedBox(height: 10,),
                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade200,
                          border: Border.all(
                              width: 2, color: Color(0xFF000080)
                          )
                      ),
                      child: TextFormField(
                        controller: _placeController,
                        decoration: InputDecoration(
                          hintText: 'place',
                          prefixIcon: Icon(Icons.place),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        ),
                        style: TextStyle(fontSize: 16),
                      ),

                    ),

                    SizedBox(height: 15,),

                    GestureDetector(
                      onTap: () async {
                        if (
                        _shopNameController.text.isEmpty &&
                            _shopTypeController.text.isEmpty &&
                            _placeController.text.isEmpty
                        ) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('The field cannot be empty'),
                            ),
                          );
                        }
                        else {
                          EasyLoading.show();
                          Response? response = await Api.addShop(
                              cityId: cities[selectedValue],
                              shopName: _shopNameController.text,
                              shopType: _shopTypeController.text,
                              place: _placeController.text);
                          EasyLoading.dismiss();
                          if (response == null) {
                            EasyLoading.showToast(
                                'Unable to communicate to server');
                          } else if (response.data['status'] == 'true') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterStatus()),
                            );
                          } else if (response.data['status'] == 'False') {
                            EasyLoading.showToast(
                                'Unable to process your request');
                          } else {
                            EasyLoading.showToast(response.toString());
                          }
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        padding: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.green.shade200,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Procced",),
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}

