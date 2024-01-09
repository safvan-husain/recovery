import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
              return Hero(
                tag: widget.heroTag,
                child: Card(
                  child: SingleChildScrollView(
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
                                        " : ",
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
              );
            }),
      )),
    );
  }
}
