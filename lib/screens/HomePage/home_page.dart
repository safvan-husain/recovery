// ignore_for_file: prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:recovery_app/models/detail_model.dart';
import 'package:recovery_app/resources/snack_bar.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';
import 'package:recovery_app/screens/search/search_screen.dart';
import 'package:recovery_app/services/csv_file_service.dart';
import 'package:recovery_app/services/home_service.dart';
import 'package:recovery_app/storage/database_helper.dart';

import '../../resources/color_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentCarouselIndex = 0;
  final ScrollController _scrollController = ScrollController();
  late Future<int> daysRemaining;

  @override
  void initState() {
    context.read<HomeCubit>().homeInitialization();
    context.read<HomeCubit>().getCrouselImages();
    daysRemaining = HomeServices.getSubsction();
    super.initState();
  }

  List<DetailsModel> filterdItems = [];
  bool isHaveSubscription = false;

  @override
  Widget build(BuildContext context) {
    double scWidth = MediaQuery.of(context).size.width;
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
        title: _buildSearchBar(context, scWidth),
        // actions: [
        //   InkWell(
        //     onTap: () {
        //       if (context.read<HomeCubit>().state.vehichalOwnerList.isEmpty) {
        //         return;
        //       }
        //       showBottomSheet(
        //         context: context,
        //         builder: (context) {
        //           return FilterBottomSheet(
        //             onFilter: (list) {
        //               _listScrollController.jumpTo(0);
        //               setState(() {
        //                 filterdItems = list;
        //               });
        //             },
        //           );
        //         },
        //       );
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Icon(
        //         FontAwesomeIcons.filter,
        //         color: filterdItems.isEmpty ? Colors.grey : Colors.blue,
        //       ),
        //     ),
        //   ),
        //   const SizedBox(width: 10),
        //   InkWell(
        //     onTap: () {
        //       Navigator.of(context).push(
        //         MaterialPageRoute(
        //           builder: (c) => const NotificationScreen(),
        //         ),
        //       );
        //     },
        //     child: const Padding(
        //       padding: EdgeInsets.all(8.0),
        //       child: Icon(
        //         FontAwesomeIcons.solidBell,
        //         color: Color.fromARGB(255, 0, 0, 0),
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              _getCarousel(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () async {
                      // context.read<HomeCubit>().downloadData();
                      // ExcelStore.processExcelInChunks();
                      // JsonDataServices.readJsonFromFileChunked();
                      // await CsvFileServices.copyAssetToDocumentDir();
                      // await CsvFileServices.getExcelFiles();
                      // await DatabaseHelper.deleteAllData();
                      // CsvFileServices.proccessFiles();
                      // print(await CsvFileServices.search("SWIFT DZIRE"));
                    },
                    child: Text(
                      "Item count",
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  )
                ],
              ),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 200),
                    child: Center(
                      child: state.changeType == ChangeType.loading
                          // child: true
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Please keep your app open, it may take a while.",
                                  style: GoogleFonts.poppins(),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Dowloading...",
                                      style: GoogleFonts.poppins(),
                                    ),
                                    CircularProgressIndicator(),
                                  ],
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        context
                                            .read<HomeCubit>()
                                            .downloadData();
                                      },
                                      child: Card(
                                        child: Container(
                                          height: 70,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Download",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        await CsvFileServices
                                            .deleteAllFilesInVehicleDetails();
                                        await DatabaseHelper.deleteAllData();
                                      },
                                      child: Card(
                                        child: Container(
                                            height: 70,
                                            alignment: Alignment.center,
                                            child: Icon(FontAwesomeIcons.user)),
                                      ),
                                    ),
                                  ].map((e) => Expanded(child: e)).toList(),
                                ),
                                Row(
                                  children: [
                                    FutureBuilder(
                                        future: daysRemaining,
                                        builder: (context, snp) {
                                          if (snp.data != null) {
                                            isHaveSubscription = snp.data! > 0;
                                          }
                                          return Card(
                                            child: Container(
                                              height: 70,
                                              alignment: Alignment.center,
                                              child: Text(
                                                snp.data == null
                                                    ? "-"
                                                    : snp.data.toString(),
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          );
                                        }),
                                    Card(
                                      child: Container(
                                          height: 70,
                                          alignment: Alignment.center,
                                          child: Icon(Icons.settings)),
                                    ),
                                  ].map((e) => Expanded(child: e)).toList(),
                                ),
                              ],
                            ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, double scWidth) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            if (isHaveSubscription) {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: SearchScreen1(),
                withNavBar: false, // OPTIONAL VALUE. True by default.
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            } else {
              DelightToastBar(
                autoDismiss: true,
                snackbarDuration: Duration(seconds: 3),
                builder: (context) => const ToastCard(
                  color: Colors.red,
                  leading: Icon(
                    Icons.flutter_dash,
                    size: 28,
                    color: Colors.red,
                  ),
                  title: Text(
                    "You don't have a subscription",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ).show(context);
            }
          },
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 10),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Search here',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                  ),
                ),
                Icon(
                  Icons.search,
                  color: Colors.black,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _getCarousel() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.changeType == ChangeType.loading &&
            state.couselImages.isEmpty) {
          return SizedBox(
            height: 50,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state.couselImages.isEmpty) {
          return Divider();
        }
        return Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                // height: 400,
                clipBehavior: Clip.none,
                viewportFraction: 0.9,
                padEnds: true,
                autoPlay: true,
                // aspectRatio: 1.80,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentCarouselIndex = index;
                  });
                },
              ),
              items: List.generate(state.couselImages.length, (index) {
                return SizedBox(
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      state.couselImages[index],
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                    ),
                  ),
                );
              }),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: DotsIndicator(
                decorator: DotsDecorator(activeColor: ColorManager.primary),
                dotsCount: state.couselImages.length,
                position: currentCarouselIndex,
              ),
            ),
          ],
        );
      },
    );
  }
}
