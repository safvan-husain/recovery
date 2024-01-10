import 'dart:convert';

import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/resources/assets_manager.dart';
import 'package:recovery_app/resources/color_manager.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';
import 'package:recovery_app/services/utils.dart';
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
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _loadController = TextEditingController();
  @override
  void initState() {
    ftutureDetails = DatabaseHelper.getDetails(widget.rowId);
    super.initState();
  }

  bool _isReporting = false;
  Map<String, String> vehicleDetails = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height -
                      (_isReporting ? 500 : 300)),
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
                    vehicleDetails = snp.data!;
                    return SingleChildScrollView(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          child: Column(
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
                        ),
                      ),
                    );
                  }),
            ),
            const SizedBox(height: 10),
            if (!_isReporting)
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isReporting = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 40)),
                  child: Text(
                    "Report",
                    style: GoogleFonts.poppins(color: Colors.white),
                  )),
            if (_isReporting) ...[
              Card(
                child: Padding(
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
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        // margin: const EdgeInsets.symmetric(
                        //     horizontal: 20, vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.2), // Color of the shadow
                              spreadRadius: 2, // Spread radius
                              blurRadius: 4, // Blur radius
                              offset: const Offset(0, 3), // Shadow offset
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _addressController,
                          // maxLength: 1000,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'street, area, locality...',
                            hintStyle: GoogleFonts.poppins(fontSize: 13),
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
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        // margin: const EdgeInsets.symmetric(
                        //     horizontal: 20, vertical: 10),
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.2), // Color of the shadow
                              spreadRadius: 2, // Spread radius
                              blurRadius: 4, // Blur radius
                              offset: const Offset(0, 3), // Shadow offset
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _loadController,
                          // maxLength: 1000,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Carries goods, load...',
                            hintStyle: GoogleFonts.poppins(fontSize: 13),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 70,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Expanded(
                            //   child: ElevatedButton(
                            //     onPressed: () {
                            //       if (_addressController.text.isNotEmpty) {
                            //         Utils.sendSMS(
                            //             '$vehicleDetails \n Reporting address : ${_addressController.text} \n carries Goods : ${_loadController.text} \n  Reporting by : ${context.read<HomeCubit>().state.user!.agent_name}');
                            //       } else {
                            //         _showAddressWarning().show(context);
                            //       }
                            //     },
                            //     style: ElevatedButton.styleFrom(
                            //         shape: RoundedRectangleBorder(
                            //             borderRadius: BorderRadius.circular(10),
                            //             side: BorderSide(
                            //                 color: ColorManager.primary,
                            //                 width: 2)),
                            //         backgroundColor: ColorManager.primary,
                            //         alignment: Alignment.center),
                            //     child: Row(
                            //       mainAxisAlignment:
                            //           MainAxisAlignment.spaceEvenly,
                            //       children: [
                            //         const Text(
                            //           "Send ",
                            //           style: TextStyle(color: Colors.white),
                            //           textAlign: TextAlign.center,
                            //         ),
                            //         Image.asset(IconAssets.sms_ic)
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            // const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (_addressController.text.isNotEmpty) {
                                      var message =
                                          '${Utils.formatMap(vehicleDetails)} \n Reporting address : ${_addressController.text} \n carries Goods : ${_loadController.text} \n  Reporting by : ${context.read<HomeCubit>().state.user!.agent_name}';
                                      String url =
                                          'whatsapp://send?phone=+917907320942&text=$message';
                                      Utils.launchURL(url);
                                    } else {
                                      _showAddressWarning().show(context);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          side: BorderSide(
                                              color: ColorManager.primary,
                                              width: 2)),
                                      backgroundColor: ColorManager.white,
                                      alignment: Alignment.center),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "Send  ",
                                        style: TextStyle(
                                            color: ColorManager.primary),
                                        textAlign: TextAlign.center,
                                      ),
                                      SvgPicture.asset(IconAssets.whatsapp_ic)
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isReporting = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40)),
                child: Text(
                  "Cancel",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              )
            ]
          ],
        ),
      )),
    );
  }

  DelightToastBar _showAddressWarning() {
    return DelightToastBar(
      autoDismiss: true,
      snackbarDuration: const Duration(seconds: 3),
      builder: (context) => const ToastCard(
        color: Colors.red,
        leading: Icon(
          Icons.flutter_dash,
          size: 28,
          color: Colors.red,
        ),
        title: Text(
          "Address is Required",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
