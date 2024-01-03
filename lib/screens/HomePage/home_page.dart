// ignore_for_file: prefer_const_constructors

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:custom_search_bar/custom_search_bar.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:recovery_app/models/detail_model.dart';
import 'package:recovery_app/resources/snack_bar.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';
import 'package:recovery_app/screens/HomePage/notification_screen.dart';
import 'package:recovery_app/screens/HomePage/widgets/bottom_sheet.dart';
import 'package:recovery_app/screens/HomePage/widgets/vehical_owner_tile.dart';
import 'package:recovery_app/screens/search/search_screen.dart';
import 'package:recovery_app/screens/title_configure/title_configure_screen.dart';
import 'package:recovery_app/services/csv_file_service.dart';
import 'package:recovery_app/services/excel_store.dart';
import 'package:recovery_app/services/json_data_services.dart';

import '../../resources/color_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentCarouselIndex = 0;
  int currentCategoryIndex = 0;
  final ScrollController _listScrollController = ScrollController();
  final ScrollController _scrollController = ScrollController();
  List<String> categoryList() => ["Bike", "Home", "Car"];
  String? currentCatValue = "USED LCV";
  @override
  void initState() {
    context.read<HomeCubit>().homeInitialization();
    context.read<HomeCubit>().getCrouselImages();
    // ExcelStore.downloadAndStore(context.read<HomeCubit>().getVehichelOwners);
    super.initState();
    _listScrollController.addListener(() {
      if (_listScrollController.position.pixels == 0) {
        _scrollController.jumpTo(_scrollController.position.minScrollExtent);
      } else if (_listScrollController.position.pixels > 100) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
      if (_listScrollController.position.atEdge) {}
    });
  }

  List<DetailsModel> filterdItems = [];

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
        actions: [
          InkWell(
            onTap: () {
              if (context.read<HomeCubit>().state.vehichalOwnerList.isEmpty) {
                return;
              }
              showBottomSheet(
                context: context,
                builder: (context) {
                  return FilterBottomSheet(
                    onFilter: (list) {
                      _listScrollController.jumpTo(0);
                      setState(() {
                        filterdItems = list;
                      });
                    },
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                FontAwesomeIcons.filter,
                color: filterdItems.isEmpty ? Colors.grey : Colors.blue,
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (c) => const NotificationScreen(),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                FontAwesomeIcons.solidBell,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ),
        ],
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
                    onTap: () {
                      // context.read<HomeCubit>().downloadData();
                      ExcelStore.processExcelInChunks();
                      // JsonDataServices.readJsonFromFileChunked();
                      // CsvFileServices.readCSVFromDocumentDir();
                    },
                    child: Text(
                      "Item count : ${filterdItems.isNotEmpty ? filterdItems.length : context.read<HomeCubit>().state.vehichalOwnerList.length}",
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  )
                ],
              ),
              // _getCategoryTabs(),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state.vehichalOwnerList.isEmpty) {
                    // log("progress : ${(state.downloadProgress ?? 0) / 10}");
                    return ConstrainedBox(
                      constraints: BoxConstraints(minHeight: 200),
                      child: Center(
                        child: state.changeType == ChangeType.loading
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    value: (state.downloadProgress ?? 0) / 100,
                                  ),
                                  if (state.downloadProgress != null)
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                          "${state.downloadProgress!.floor()} %"),
                                    )
                                ],
                              )
                            : ElevatedButton(
                                onPressed: () async {
                                  if (state.files.isEmpty) {
                                    showSnackbar(
                                      "Started to download data",
                                      context,
                                      Icons.downloading,
                                    );
                                    context.read<HomeCubit>().downloadData();
                                  } else {
                                    //TODO: loading.
                                    // List<List<String?>> titlesOfSheets =
                                    //     await ExcelStore.getAllListSheetTitles(
                                    //         context
                                    //             .read<HomeCubit>()
                                    //             .state
                                    //             .files);
                                    if (context.mounted) {
                                      PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: TitleConfigure(
                                          titlesOfSheets: [],
                                        ),
                                        withNavBar:
                                            false, // OPTIONAL VALUE. True by default.
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.cupertino,
                                      );
                                    }

                                    //TODO: configute logic.
                                  }
                                },
                                child: Text(
                                  state.files.isEmpty
                                      ? "Download"
                                      : "Configure",
                                  style:
                                      GoogleFonts.poppins(color: Colors.white),
                                ),
                              ),
                      ),
                    );
                  }
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height,
                    ),
                    child: ListView.builder(
                        controller: _listScrollController,
                        itemCount: filterdItems.isNotEmpty
                            ? filterdItems.length
                            : state.vehichalOwnerList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return VehichelOwnerTile(
                            detailsModel: filterdItems.isNotEmpty
                                ? filterdItems.elementAt(index)
                                : state.vehichalOwnerList.elementAt(index),
                          );
                        }),
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
          // onTap: () => showSearchForCustomiseSearchDelegate<DetailsModel>(
          //   context: context,
          //   delegate: SearchScreen(
          //     items: filterdItems.isNotEmpty
          //         ? filterdItems
          //         : state.vehichalOwnerList,
          //     filter: (item) => [item.name, item.engineNo, item.vehicalNo],
          //     itemBuilder: (item) {
          //       return Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //         child: VehichelOwnerTile(detailsModel: item),
          //       );
          //     },
          //     appBarBuilder:
          //         (controller, onSubmitted, textInputAction, focusNode) {
          //       return PreferredSize(
          //         preferredSize: Size(double.infinity, 80),
          //         child: Padding(
          //           padding: const EdgeInsets.only(top: 20.0),
          //           child: SearchBar(
          //             elevation: MaterialStatePropertyAll(0),
          //             shape: MaterialStatePropertyAll(RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(10))),
          //             controller: controller,
          //             hintText: "Search",
          //             hintStyle: MaterialStatePropertyAll(
          //                 TextStyle(color: ColorManager.grey)),
          //             onSubmitted: onSubmitted,
          //             leading: IconButton(
          //                 onPressed: () => onSubmitted,
          //                 icon: Icon(
          //                   Icons.search,
          //                   color: ColorManager.grey,
          //                 )),
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
          onTap: () {
            PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: SearchScreen1(),
              withNavBar: false, // OPTIONAL VALUE. True by default.
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
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

  Widget _getCategoryTabs() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(categoryList().length, (index) {
            return InkWell(
              onTap: () async {
                setState(() {
                  currentCategoryIndex = index;
                });
                // PersistentNavBarNavigator.pushNewScreen(
                //   context,
                //   screen: const CategoryListView(),
                //   withNavBar: true, // OPTIONAL VALUE. True by default.
                //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
                // );
                // await ExcelStore.downloadFile(
                //     "https://www.recovery.starkinsolutions.com//uploads/bank_proof/ADI1dt9RG5/REPO%20LIST%20MARCH%202023%20-PUNE%20HUB.xlsx");
                // context.read<HomeCubit>().getVehichelOwners();
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
                  categoryList()[index],
                  style: TextStyle(
                      color: currentCategoryIndex == index
                          ? ColorManager.white
                          : Colors.black,
                      fontSize: 15),
                ),
              ),
            );
          }),
        ));
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
