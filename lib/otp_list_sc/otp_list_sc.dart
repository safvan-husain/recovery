import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:recovery_app/vehical_info_sc/vehical_info_sc.dart';

import '../models/model.dart';
import '../resources/color_manager.dart';

class OtpListView extends StatefulWidget {
  const OtpListView({super.key});

  @override
  State<OtpListView> createState() => _OtpListViewState();
}

class _OtpListViewState extends State<OtpListView> {
  TextEditingController _searchBarController = TextEditingController();

  List<OtpModel> detailsList()=>[
    OtpModel(name: "Marvin McKinney", phoneNo: "AS-01-BC-3353", otp: "UP77AN3725"),
    OtpModel(name: "Marvin McKinney", phoneNo: "AS-01-BC-3353", otp: "UP77AN3725"),
    OtpModel(name: "Marvin McKinney", phoneNo: "AS-01-BC-3353", otp: "UP77AN3725"),
    OtpModel(name: "Marvin McKinney", phoneNo: "AS-01-BC-3353", otp: "UP77AN3725"),
  ];

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.primary,
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: ColorManager.primary,
          statusBarColor: ColorManager.primary,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
        title: Text("Bikes",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 25),),
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
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
            itemCount: detailsList().length,
            shrinkWrap: true,
            itemBuilder: (context,index){
              return _getListTile(width: scWidth, index: index);
            }),
      ),
    );
  }

  Widget _getListTile({required double width,required int index}){
    return InkWell(
      onTap: (){
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: VehicalInfoView(),
          withNavBar: true, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        width: width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [      BoxShadow(
                color: Colors.grey.withOpacity(0.2), //New
                blurRadius: 5.0,
                offset: Offset(0, 10))]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment:MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(

                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Name",style:TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold) ,),
                        SizedBox(width: 15,),
                        Text(":",style:TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold) ,),
                        SizedBox(width: 15,),
                        Text("${detailsList()[index].name}",style:TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold) ,),
                      ],),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(

                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Phone No",style:TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold) ,),
                        SizedBox(width: 15,),
                        Text(":",style:TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold) ,),
                        SizedBox(width: 15,),
                        Text("${detailsList()[index].phoneNo}",style:TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold) ,),
                      ],),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(

                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("OTP",style:TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold) ,),
                        SizedBox(width: 15,),
                        Text(":",style:TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold) ,),
                        SizedBox(width: 15,),
                        Text("${detailsList()[index].otp}",style:TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold) ,),
                      ],),
                  ),
                ],),
            ),

          ],),
      ),
    );
  }
}
