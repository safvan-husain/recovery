// ignore_for_file: prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:recovery_app/catagories_sc/categories_sc.dart';

import 'package:recovery_app/models/model.dart';
import 'package:recovery_app/vehical_info_sc/vehical_info_sc.dart';

import '../category_list_sc/category_list_sc.dart';
import '../resources/color_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchBarController = TextEditingController();
  int currentCarouselIndex = 0;
  int currentCategoryIndex = 0;

  List<String> carouselItems() => [
        "https://images.unsplash.com/photo-1682686581221-c126206d12f0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxfHx8ZW58MHx8fHx8&auto=format&fit=crop&w=500&q=60",
        "https://images.unsplash.com/photo-1682686581663-179efad3cd2f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxNnx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
        "https://images.unsplash.com/photo-1682695797873-aa4cb6edd613?ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwyMXx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60"
      ];

  List<String> categoryList() => ["Bike", "Home", "Car"];

  List<DetailsModel> detailsList() => [
        DetailsModel(
            name: "Marvin McKinney",
            engineNo: "AS-01-BC-3353",
            vehicalNo: "UP77AN3725"),
        DetailsModel(
            name: "Marvin McKinney",
            engineNo: "AS-01-BC-3353",
            vehicalNo: "UP77AN3725"),
        DetailsModel(
            name: "Marvin McKinney",
            engineNo: "AS-01-BC-3353",
            vehicalNo: "UP77AN3725"),
        DetailsModel(
            name: "Marvin McKinney",
            engineNo: "AS-01-BC-3353",
            vehicalNo: "UP77AN3725"),
        DetailsModel(
            name: "Marvin McKinney",
            engineNo: "AS-01-BC-3353",
            vehicalNo: "UP77AN3725"),
      ];
  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
    double scHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ColorManager.statusbarColor,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
        ),
        title: Container(
          margin: EdgeInsets.symmetric(vertical: 30),
          // padding: EdgeInsets.symmetric(horizontal: 10),
          height: 40, width: scWidth,
          decoration: BoxDecoration(
            border: Border.all(
                color: Colors.black,
                width: 1,
                strokeAlign: BorderSide.strokeAlignOutside),
            // color: Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SearchBar(
            elevation: MaterialStatePropertyAll(0),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
            controller: _searchBarController,
            hintText: "Search",
            hintStyle:
                MaterialStatePropertyAll(TextStyle(color: ColorManager.grey)),
            leading: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  color: ColorManager.grey,
                )),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              _getCarousel(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Categories",
                    style: TextStyle(color: ColorManager.primary, fontSize: 20),
                  ),
                  TextButton(
                      onPressed: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: CategoriesScView(),
                          withNavBar: true, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                      child: Text(
                        "See All",
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ))
                ],
              ),
              _getCategoryTabs(),
              Container(
                height: scHeight * 0.5,
                child: ListView.builder(
                    itemCount: detailsList().length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return _getListTile(width: scWidth, index: index);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getListTile({required double width, required int index}) {
    return InkWell(
      onTap: () {
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
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2), //New
                  blurRadius: 5.0,
                  offset: Offset(0, 10))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Name",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          ":",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "${detailsList()[index].name}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Vehicle No",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          ":",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "${detailsList()[index].vehicalNo}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Engine No",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          ":",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "${detailsList()[index].engineNo}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 140,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                color: ColorManager.primary,
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 30,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getCategoryTabs() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(categoryList().length, (index) {
            return InkWell(
              onTap: () {
                setState(() {
                  currentCategoryIndex = index;
                });
              },
              child: InkWell(
                onTap: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: const CategoryListView(),
                    withNavBar: true, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: currentCategoryIndex == index
                          ? ColorManager.primary
                          : ColorManager.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.2), //New
                            blurRadius: 5.0,
                            offset: Offset(0, 10))
                      ]),
                  child: Text(
                    "${categoryList()[index]}",
                    style: TextStyle(
                        color: currentCategoryIndex == index
                            ? ColorManager.white
                            : Colors.black,
                        fontSize: 15),
                  ),
                ),
              ),
            );
          }),
        ));
  }

  Widget _getCarousel() {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            aspectRatio: 1.80,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                currentCarouselIndex = index;
              });
            },
          ),
          items: List.generate(carouselItems().length, (index) {
            return Container(
              margin: EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                // child: Image.network(carouselItems()[index]),
              ),
            );
          }),
        ),
        DotsIndicator(
          decorator: DotsDecorator(activeColor: ColorManager.primary),
          dotsCount: carouselItems().length,
          position: currentCarouselIndex,
        )
      ],
    );
  }
}
