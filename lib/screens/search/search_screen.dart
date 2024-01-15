import 'dart:async';
import 'dart:developer';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';
import 'package:recovery_app/screens/search/item_screen.dart';
import 'package:recovery_app/services/utils.dart';
import 'package:recovery_app/storage/database_helper.dart';
import 'package:recovery_app/storage/node_model.dart';

class SearchScreen1 extends StatefulWidget {
  const SearchScreen1({super.key});

  @override
  State<SearchScreen1> createState() => SearchScreen1State();
}

class SearchScreen1State extends State<SearchScreen1> {
  late Future<List<String>> futureTitles;
  bool _isSearchComplete = false;
  final TextEditingController _controller = TextEditingController();
  // final _streamController = StreamController<Map<String, dynamic>>();

  @override
  void initState() {
    super.initState();
  }

  CancelableOperation<List<SearchResultItem>>? operation;
  List<SearchResultItem> items = [];
  @override
  void dispose() {
    // _streamController.close();
    super.dispose();
  }

  bool isAllNumbers = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              height: 60,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Color of the shadow
                    spreadRadius: 2, // Spread radius
                    blurRadius: 4, // Blur radius
                    offset: const Offset(0, 3), // Shadow offset
                  ),
                ],
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 100,
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: " eg: 1301",
                          prefixIcon: InkWell(
                              onTap: () async {},
                              child: const CircleAvatar(
                                  child: Icon(Icons.search))),
                          prefixIconConstraints:
                              const BoxConstraints(minWidth: 50),
                          suffixIconConstraints:
                              const BoxConstraints(minWidth: 80),
                          suffix: InkWell(
                            onTap: () {
                              _controller.text = '';
                            },
                            child: const Icon(
                              FontAwesomeIcons.x,
                              color: Colors.grey,
                            ),
                          )),
                      controller: _controller,
                      onChanged: (value) async {
                        if (context.mounted) {
                          setState(() {
                            isAllNumbers = RegExp(r'^\d+$').hasMatch(value);
                            _isSearchComplete = false;
                          });
                        }
                        if (operation != null) {
                          operation!.cancel();
                        }
                        if (value.isNotEmpty) {
                          operation = CancelableOperation.fromFuture(
                            DatabaseHelper.showForPrefix(
                              Utils.removeHyphens(_controller.text),
                            ),
                          );
                        }

                        if (operation != null) {
                          try {
                            items = await operation!.value;
                            _isSearchComplete = true;
                            if (context.mounted) setState(() {});
                          } catch (e) {
                            log("guss the operation canceld");
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (isAllNumbers && _isSearchComplete) ...[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                height: 60,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.grey.withOpacity(0.5), // Color of the shadow
                      spreadRadius: 2, // Spread radius
                      blurRadius: 4, // Blur radius
                      offset: const Offset(0, 3), // Shadow offset
                    ),
                  ],
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 100,
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "filter here eg: MH or RJ",
                      prefixIcon: InkWell(
                          onTap: () async {},
                          child: const CircleAvatar(child: Icon(Icons.search))),
                      prefixIconConstraints: const BoxConstraints(minWidth: 50),
                    ),
                    onChanged: (value) async {
                      if (value.isEmpty) {
                        if (operation != null) {
                          operation!.cancel();
                        }
                        if (_controller.text.isNotEmpty) {
                          operation = CancelableOperation.fromFuture(
                            DatabaseHelper.showForPrefix(
                              Utils.removeHyphens(_controller.text),
                            ),
                          );
                        }

                        if (operation != null) {
                          try {
                            items = await operation!.value;
                            _isSearchComplete = true;
                            if (context.mounted) setState(() {});
                          } catch (e) {
                            log("guss the operation canceld");
                          }
                        }
                      } else {
                        items = items
                            .where((element) => element.item.contains(value))
                            .toList();
                      }
                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
            const SizedBox(
              height: 10,
            ),
            if (items.isEmpty && _controller.text.isNotEmpty) ...[
              const SizedBox(
                height: 100,
              ),
              Center(
                child: Text("No search results for ${_controller.text}"),
              )
            ] else
              Container(
                padding: EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height -
                    (isAllNumbers && _isSearchComplete ? 250 : 150),
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return Divider(
                      indent: 20,
                      endIndent: 20,
                      color: Colors.grey[300],
                    );
                  },
                  itemCount: context.read<HomeCubit>().state.isTwoColumnSearch
                      ? ((items.length + 1) ~/
                          2) // Corrected itemCount calculation
                      : items.length,
                  itemBuilder: (context, index) {
                    if (context.read<HomeCubit>().state.isTwoColumnSearch) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        child: Row(
                          children: [
                            Expanded(
                                child: _itemListTile(context,
                                    index * 2)), // First item in the row
                            if (index * 2 + 1 < items.length) ...[
                              // Check if there is a second item
                              VerticalDivider(
                                color: Colors.grey[300],
                              ),
                              Expanded(
                                  child: _itemListTile(context,
                                      index * 2 + 1)) // Second item in the row
                            ],
                          ],
                        ),
                      );
                    }
                    return _itemListTile(context, index);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  InkWell _itemListTile(BuildContext context, int index) {
    return InkWell(
      onTap: () async {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (c) => ItemScreen(
              rowId: items[index].rowIds[0],
              rowIds: context.read<HomeCubit>().state.user!.isStaff
                  ? items[index].rowIds
                  : null,
              heroTag: items[index].item.toUpperCase(),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              items[index].item.toUpperCase(),
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
