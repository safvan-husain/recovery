import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/resources/snack_bar.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';
import 'package:recovery_app/screens/search/widgets/report_inputs.dart';
import 'package:recovery_app/screens/search/widgets/report_screen.dart';
import 'package:recovery_app/services/utils.dart';

class SingleItemScreen extends StatefulWidget {
  final Map<String, String> details;
  final String heroTag;
  const SingleItemScreen({
    super.key,
    required this.details,
    required this.heroTag,
  });

  @override
  State<SingleItemScreen> createState() => _SingleItemScreenState();
}

class _SingleItemScreenState extends State<SingleItemScreen> {
  List<String> titles = [
    "VEHICAL NO",
    "CHASSIS NO",
    "MODEL/MAKE",
    "ENGINE NO",
    "AGREEMENT NO",
    "CUSTOMER NAME",
    "CUSTOMER ADDRESS",
  ].map((e) => e.toLowerCase()).toList();

  @override
  void initState() {
    if (context.read<HomeCubit>().state.user!.isStaff) {
      titles.addAll(
        [
          "BUCKET",
          "GV",
          "OD REGION",
          "AREA",
          'BRANCH YEAR',
          'LEVEL1 ',
          'LEVEL 2',
          'LEVEL 3',
          'FINANCE',
          'BRANCH',
          'CONTACT 1',
          'CONTACT 2',
          'CONTACT 3 ',
          'SEC9AVAILA',
          'SEC17AVAILABLE',
          'TBRFLAG',
          'SEASONING',
          "MAILID 1",
          "MAILID2",
          "EXECUTIVE NAME",
          "POS",
          "TOSS",
          "CUSTOMER CONTACT NO",
          " REMARK",
          "UPLOADED ON",
          'file name',
        ].map((e) => e.toLowerCase()),
      );
    }
    super.initState();
  }

  bool _isReporting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: titles
                          .map((e) => MapEntry(e, widget.details[e] ?? ""))
                          .map((e) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
              ),
            ),
            const SizedBox(height: 10),
            if (!_isReporting)
              if (context.read<HomeCubit>().state.user!.isStaff)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: {
                    "Confirm": Icons.done_outline_rounded,
                    "Whatsapp": Icons.message,
                    "Ok Repo": Icons.chair,
                    "Cancel": Icons.cancel,
                    "Copy": Icons.copy
                  }
                      .entries
                      .map((e) => InkWell(
                            onTap: () {
                              takeActionForSpecificButton(
                                e.key,
                                titles.fold(
                                  {},
                                  (map, e) {
                                    map[e] = widget.details[e] ?? "";
                                    return map;
                                  },
                                ),
                              );
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(e.value),
                                Text(e.key),
                              ],
                            ),
                          ))
                      .toList(),
                )
              else
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
              ReportInputs(
                titles.fold(
                  {},
                  (map, e) {
                    map[e] = widget.details[e] ?? "";
                    return map;
                  },
                ),
                'Report',
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

  void takeActionForSpecificButton(
    String button,
    Map<String, String> details,
  ) {
    switch (button) {
      case "Confirm":
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (c) => ReportScreen(
              title: button,
              details: details,
            ),
          ),
        );
        break;
      case "Whatsapp":
        showModalBottomSheet(
          context: context,
          builder: (c) {
            String agentName = context.read<HomeCubit>().state.user!.agent_name;
            String phone = context.read<HomeCubit>().state.user!.number;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    Utils.sendWhatsapp(
                      details,
                      'Bank for confirmation',
                      agentName,
                      phone,
                      '',
                    );
                  },
                  child: ListTile(
                    leading: const Icon(FontAwesomeIcons.buildingColumns),
                    title: Text(
                      'Bank for confirmation',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Utils.sendWhatsapp(
                      details,
                      'Ok for confirmation',
                      agentName,
                      phone,
                      '',
                    );
                  },
                  child: ListTile(
                    leading: const Icon(Icons.done),
                    title: Text(
                      'Ok for Report',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Utils.sendWhatsapp(
                      details,
                      'Not confirmed',
                      agentName,
                      phone,
                      '',
                    );
                  },
                  child: ListTile(
                    leading: const Icon(Icons.cancel),
                    title: Text(
                      'Not confirmed',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                ),
              ],
            );
          },
        );
        break;
      case "Ok Repo":
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (c) => ReportScreen(
              title: button,
              details: details,
            ),
          ),
        );
        break;
      case "Cancel":
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (c) => ReportScreen(
              title: button,
              details: details,
            ),
          ),
        );
        break;
      case "Copy":
        copyToClipboard(Utils.formatMap(details));
        showSnackbar('Copied!', context, Icons.copy);
        break;
      default:
    }
  }
}

void copyToClipboard(String text) {
  Clipboard.setData(ClipboardData(text: text));
}
