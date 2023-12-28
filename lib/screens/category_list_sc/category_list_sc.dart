import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:recovery_app/models/detail_model.dart';
import 'package:recovery_app/screens/vehical_info_sc/vehical_info_sc.dart';

import '../../models/otp_model.dart';
import '../../resources/color_manager.dart';

class CategoryListView extends StatefulWidget {
  const CategoryListView({super.key});

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  TextEditingController _searchBarController = TextEditingController();

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
        leading: const BackButton(),
        backgroundColor: ColorManager.primary,
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: ColorManager.primary,
          statusBarColor: ColorManager.primary,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
        centerTitle: true,
        title: const Text(
          "Bikes",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 25),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            // padding: EdgeInsets.symmetric(horizontal: 10),
            height: 40, width: scWidth,
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.black,width: 1,strokeAlign: BorderSide.strokeAlignOutside),
              // color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SearchBar(
              backgroundColor:
                  MaterialStatePropertyAll(ColorManager.searchBarBackColor),
              elevation: const MaterialStatePropertyAll(0),
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
              controller: _searchBarController,
              hintText: "Search",
              hintStyle: MaterialStatePropertyAll(
                  TextStyle(color: ColorManager.white)),
              leading: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.search,
                    color: ColorManager.white,
                  )),
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
            itemCount: detailsList().length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return _getListTile(width: scWidth, index: index);
            }),
      ),
    );
  }

  Widget _getListTile({required double width, required int index}) {
    return InkWell(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: VehicalInfoView(
            detailsModel: detailsList()[0],
          ),
          withNavBar: true, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        width: width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2), //New
                  blurRadius: 5.0,
                  offset: const Offset(0, 10))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Name",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        const Text(
                          ":",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          "${detailsList()[index].name}",
                          style: const TextStyle(
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
                        const Text(
                          "Vehicle No",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        const Text(
                          ":",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          detailsList()[index].vehicalNo,
                          style: const TextStyle(
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
                        const Text(
                          "Engine No",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        const Text(
                          ":",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          "${detailsList()[index].engineNo}",
                          style: const TextStyle(
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
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                color: ColorManager.primary,
              ),
              child: const Icon(
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
}
