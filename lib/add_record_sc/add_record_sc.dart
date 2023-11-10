import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:recovery_app/HomePage/home_page.dart';
import 'package:recovery_app/resources/assets_manager.dart';

import '../resources/color_manager.dart';


class AddNewRecordScView extends StatefulWidget {
  const AddNewRecordScView({super.key});

  @override
  State<AddNewRecordScView> createState() => _AddNewRecordScViewState();
}

class _AddNewRecordScViewState extends State<AddNewRecordScView>
    with TickerProviderStateMixin {
  final TextEditingController _vehicalNumController = TextEditingController();
  final TextEditingController _chassiNoController = TextEditingController();
  final TextEditingController _vehicalModelController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 10));
    // _sizeAnimation =
    //     Tween<double>(begin: 50.0, end: 200.0).animate(_controller);
    // _controller.forward();
    // _controller.addListener(() {
    //   setState(() {});
    // });
  }



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
        leading: BackButton(
          color: Colors.white,
        ),
        centerTitle: true,
        title: Text(
          "Add New Record",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              _getTextField(
                  hint: "Vehicle Number",
                  textEditingController: _vehicalNumController),
              _getTextField(
                  hint: "Chassis No",
                  textEditingController: _chassiNoController),
              _getTextField(
                  hint: "Vehicle Model",
                  textEditingController: _vehicalModelController),
              _getTextField(
                  hint: "Bank/NBFC Name",
                  textEditingController: _bankNameController),
              _getTextField(
                  hint: "Customer Name",
                  textEditingController: _customerNameController),
             const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () => _getDialog(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primary,
                      alignment: Alignment.center),
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                        textScaleFactor: 1.5,
                        textAlign: TextAlign.center,
                      )))
            ],
          ),
        ),
      ),
    );
  }

  Future _getDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
            margin: EdgeInsets.symmetric(vertical: 200, horizontal: 20),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Stack(

              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 50,
                  child: Container(
                    alignment: Alignment.center,
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: CupertinoColors.activeBlue,
                    ),
                    child: Image.asset(IconAssets.check_ic,height: 100,width: 100,).animate(
                        controller: _controller,
                        onPlay: (controller)=>controller.repeat(reverse: true,min: 0.15,max: 0.2),
                        autoPlay: true,
                        effects: [
                          ScaleEffect(duration: Duration(seconds: 2),curve: Curves.easeOutBack),
                          // Effect(duration: Duration(seconds: 2), curve: Curves.easeInOut,begin: 0.1,end: 0.3)
                        ]).scale(),
                  ),
                ),

                Positioned(
                  top: 30,
                  left: 20,
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: CupertinoColors.activeBlue,
                    ),
                  ).animate(
                    controller: _controller,
                    onPlay: (controller)=>controller.repeat(reverse: true,min: 0.1,max: 0.2),
                      autoPlay: true,
                      effects: [
                        ScaleEffect(duration: Duration(seconds: 2),curve: Curves.easeOutBack),
                    // Effect(duration: Duration(seconds: 2), curve: Curves.easeInOut,begin: 0.1,end: 0.3)
                  ]).scale(),
                ),

                Positioned(
                  top: 40,
                  right: 30,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: CupertinoColors.activeBlue,
                    ),
                  ).animate(
                      controller: _controller,
                      onPlay: (controller)=>controller.repeat(reverse: true,min: 0.1,max: 0.2),
                      autoPlay: true,
                      effects: [
                        ScaleEffect(duration: Duration(seconds: 2),curve: Curves.easeOutBack),
                        // Effect(duration: Duration(seconds: 2), curve: Curves.easeInOut,begin: 0.1,end: 0.3)
                      ]).scale(),
                ),
                Positioned(
                  bottom: 200,
                  left: 40,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: CupertinoColors.activeBlue,
                    ),
                  ).animate(
                      controller: _controller,
                      onPlay: (controller)=>controller.repeat(reverse: true,min: 0.1,max: 0.2),
                      autoPlay: true,
                      effects: [
                        ScaleEffect(duration: Duration(seconds: 2),curve: Curves.easeOutBack),
                        // Effect(duration: Duration(seconds: 2), curve: Curves.easeInOut,begin: 0.1,end: 0.3)
                      ]).scale(),
                ),

                Positioned(
                  bottom: 0,
                  child: Column(
                    children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Text("Completed 😘",style: TextStyle(color: ColorManager.primary,fontSize: 20),),
                    ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.primary,
                              alignment: Alignment.center),
                          child: const Text(
                            "Done",
                            style: TextStyle(color: Colors.white),
                            textScaleFactor: 1.5,
                            textAlign: TextAlign.center,
                          )),
                      SizedBox(height: 20)
                  ],)
                ),
              ],
            ));
      },
    );
  }

  Widget _getTextField(
      {required String hint,
      required TextEditingController textEditingController}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        decoration: InputDecoration(
            hintText: hint,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorManager.grey, width: 1)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorManager.primary, width: 1))),
        controller: textEditingController,
      ),
    );
  }
}
