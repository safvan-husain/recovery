import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/resources/assets_manager.dart';
import 'package:recovery_app/resources/color_manager.dart';
import 'package:recovery_app/storage/database_helper.dart';

class SingleItemScreen extends StatefulWidget {
  final int rowId;
  final String heroTag;
  const SingleItemScreen({
    super.key,
    required this.rowId,
    required this.heroTag,
  });

  @override
  State<SingleItemScreen> createState() => _SingleItemScreenState();
}

class _SingleItemScreenState extends State<SingleItemScreen> {
  late final Future<Map<String, String>?> ftutureDetails;
  @override
  void initState() {
    ftutureDetails = DatabaseHelper.getDetails(widget.rowId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: ftutureDetails,
            builder: (context, snp) {
              if (snp.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snp.hasData) {
                return const Center(
                  child: Text("No data availible"),
                );
              }
              return Card(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    child: Column(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: snp.data!.entries
                              .where((element) =>
                                  element.value.toString().isNotEmpty)
                              .map((e) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            e.key,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          " :    ",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Text(
                                              e.value.toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            )),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Vehichel Address',
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                // margin: const EdgeInsets.symmetric(
                                //     horizontal: 20, vertical: 10),
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(
                                          0.2), // Color of the shadow
                                      spreadRadius: 2, // Spread radius
                                      blurRadius: 4, // Blur radius
                                      offset:
                                          const Offset(0, 3), // Shadow offset
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  // maxLength: 1000,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'street, area, locality...',
                                    labelStyle:
                                        GoogleFonts.poppins(fontSize: 13),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Carries Goods',
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                // margin: const EdgeInsets.symmetric(
                                //     horizontal: 20, vertical: 10),
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(
                                          0.2), // Color of the shadow
                                      spreadRadius: 2, // Spread radius
                                      blurRadius: 4, // Blur radius
                                      offset:
                                          const Offset(0, 3), // Shadow offset
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  // maxLength: 1000,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Carries goods, load...',
                                    labelStyle:
                                        GoogleFonts.poppins(fontSize: 13),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: BorderSide(
                                                  color: ColorManager.primary,
                                                  width: 2)),
                                          backgroundColor: ColorManager.primary,
                                          alignment: Alignment.center),
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 30),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                "Send ",
                                                style: TextStyle(
                                                    color: Colors.white),
                                                textAlign: TextAlign.center,
                                              ),
                                              // Image.asset(
                                              //   IconAssets.sms_ic,
                                              // )
                                            ],
                                          ))),
                                  ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: BorderSide(
                                                  color: ColorManager.primary,
                                                  width: 2)),
                                          backgroundColor: ColorManager.white,
                                          alignment: Alignment.center),
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 30),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                "Send  ",
                                                style: TextStyle(
                                                    color:
                                                        ColorManager.primary),
                                                textAlign: TextAlign.center,
                                              ),
                                              // SvgPicture.asset(
                                              //     IconAssets.whatsapp_ic)
                                            ],
                                          ))),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      )),
    );
  }
}
