import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemScreen extends StatelessWidget {
  final Map<String, String> details;
  const ItemScreen({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: details.entries
                    .where((element) => element.value.isNotEmpty)
                    .map((e) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  "${e.key}",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                " : ",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    e.value,
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
      )),
    );
  }
}
