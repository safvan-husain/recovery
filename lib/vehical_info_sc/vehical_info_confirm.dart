import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recovery_app/generated/assets.dart';
import 'package:recovery_app/resources/assets_manager.dart';

import '../models/model.dart';
import '../resources/color_manager.dart';

class VehicalInfoConfirmView extends StatefulWidget {
  const VehicalInfoConfirmView({super.key});

  @override
  State<VehicalInfoConfirmView> createState() => _VehicalInfoConfirmViewState();
}

class _VehicalInfoConfirmViewState extends State<VehicalInfoConfirmView> {
  TextEditingController _searchBarController = TextEditingController();
  TextEditingController _vehicalAddrController = TextEditingController();
  TextEditingController _goodsController = TextEditingController();

  List<DetailsModel> detailsList()=>[
    DetailsModel(name: "Marvin McKinney", engineNo: "AS-01-BC-3353", vehicalNo: "UP77AN3725"),
    DetailsModel(name: "Marvin McKinney", engineNo: "AS-01-BC-3353", vehicalNo: "UP77AN3725"),
    DetailsModel(name: "Marvin McKinney", engineNo: "AS-01-BC-3353", vehicalNo: "UP77AN3725"),
    DetailsModel(name: "Marvin McKinney", engineNo: "AS-01-BC-3353", vehicalNo: "UP77AN3725"),
    DetailsModel(name: "Marvin McKinney", engineNo: "AS-01-BC-3353", vehicalNo: "UP77AN3725"),
  ];

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: ColorManager.primary,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: ColorManager.primary,
          statusBarColor: ColorManager.primary,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
        leading: BackButton(),
        title: Text("Vehical Information",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 25),),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
            // padding: EdgeInsets.symmetric(horizontal: 10),
            height: 40,width: scWidth ,
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.black,width: 1,strokeAlign: BorderSide.strokeAlignOutside),
              // color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SearchBar(
              backgroundColor: MaterialStatePropertyAll(ColorManager.searchBarBackColor),
              elevation: MaterialStatePropertyAll(0),
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              controller: _searchBarController,

              hintText: "Search",
              hintStyle: MaterialStatePropertyAll(TextStyle(color: ColorManager.white)),
              leading: IconButton(onPressed: ()  {}, icon: Icon(Icons.search,color: ColorManager.white,)),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
            padding: EdgeInsets.all(10),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: ColorManager.grey.withOpacity(00.2)),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                children: [
                  Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.top,
                    columnWidths: const {
                      0: FlexColumnWidth(5),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(5),
                    },
                    children: [
                      _getInfoTile(title: "Name", value: "Devesh Kharade"),
                      _getInfoTile(title: "Vehicle No", value: "AS-01-BC-3353"),
                      _getInfoTile(title: "Chassis No", value: "UP77AN3725"),
                      _getInfoTile(title: "Contact 1", value: "(704) 555-0127"),
                      _getInfoTile(title: "Contact 2", value: "(808) 555-0111"),
                      _getInfoTile(title: "Location", value: "1901 Thornridge\n Cir. Shiloh, \nHawaii 81063"),
                      _getInfoTile(title: "Level 1", value: ""),
                      _getInfoTile(title: "Level 2", value: ""),
                      _getInfoTile(title: "Agreement No", value: ""),
                      _getInfoTile(title: "Finance", value: "The Walt Disney"),
                      _getInfoTile(title: "Branch", value: "The Walt Disney"),
                      _getInfoTile(title: "Contact", value: "(808) 555-0111"),
                      _getInfoTile(title: "Contact", value: "(808) 555-0111"),
                      _getInfoTile(title: "Contact", value: "(808) 555-0111"),
                    ],),

                  SizedBox(height: 30,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          onPressed: (){},
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(color: ColorManager.primary,width: 2)),

                              backgroundColor: ColorManager.primary,alignment: Alignment.center),
                          child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 30),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text("Send ",style: TextStyle(color: Colors.white),textScaleFactor: 1.1,textAlign: TextAlign.center,),
                                  Image.asset(IconAssets.sms_ic,)
                                ],
                              ))
                      ),

                      ElevatedButton(
                          onPressed: (){},
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(color: ColorManager.primary,width: 2)),
                              backgroundColor: ColorManager.white,alignment: Alignment.center),
                          child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 30),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text("Send  ",style: TextStyle(color: ColorManager.primary),textScaleFactor: 1.1,textAlign: TextAlign.center,),
                                  SvgPicture.asset(IconAssets.whatsapp_ic)
                                ],
                              ))
                      ),
                    ],
                  )
                ],
              ),
            )
        ),
      ),
    );
  }

  Widget _getTextField({required TextEditingController controller,required String hintText}){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        decoration:  InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorManager.primary, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          hintText: hintText,
        ),
      ),
    );
  }

  TableRow _getInfoTile({required String title,required String value}){
    return TableRow(
      children: [
        Text(title,style: TextStyle(color: Colors.black,fontSize: 15),),
        Text(":",style: TextStyle(color: Colors.black,fontSize: 15),),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text("$value",style: TextStyle(color: Colors.black,fontSize: 15),),
        ),

      ],);
  }
}