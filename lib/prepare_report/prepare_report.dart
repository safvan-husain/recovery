import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../resources/color_manager.dart';

class PrepareReportView extends StatefulWidget {
  const PrepareReportView({super.key});

  @override
  State<PrepareReportView> createState() => _PrepareReportViewState();
}

class _PrepareReportViewState extends State<PrepareReportView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.primary,
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: ColorManager.primary,
          statusBarColor: ColorManager.primary,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
        leading: BackButton(color: Colors.white,),
        centerTitle: true,
        title: Text("Prepare Report",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 25),),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ElevatedButton(onPressed: (){

        },
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: ColorManager.addBtnColor.withOpacity(0.5),
            side: BorderSide(color: ColorManager.primary,width: 1)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text("Add",style: TextStyle(color: Colors.black,),textScaleFactor: 1.5,),
            Icon(Icons.add,color: Colors.black,)
          ],),
        ),
      ),
    );
  }
}
