import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/screens/search/widgets/searched_items_view.dart';
import 'package:recovery_app/services/excel_store.dart';

class SearchScreen1 extends StatefulWidget {
  const SearchScreen1({super.key});

  @override
  State<SearchScreen1> createState() => SearchScreen1State();
}

class SearchScreen1State extends State<SearchScreen1> {
  late Future<List<String>> futureTitles;
  List<String> selectedItems = [];
  bool _isConfirm = false;
  bool _isSearch = false;
  List<FoundItem> items = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    futureTitles = ExcelStore.getAllTitles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize:
            Size(MediaQuery.of(context).size.width, _isSearch ? 80 : 60),
        child: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back_ios),
          ),
          title: _isSearch
              ? Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: Colors.black,
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignOutside),
                    // color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "search here",
                        prefixIcon: Icon(Icons.search)),
                    controller: _controller,
                    onChanged: (value) async {
                      items =
                          await ExcelStore.searchItems(selectedItems, value);
                      setState(() {});
                    },
                  ),
                )
              : Text(
                  _isConfirm ? "Confirm fields" : "Select fields for search"),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              child: _isSearch
                  ? SearchedItemsView(items: items)
                  : _isConfirm
                      ? ListView.builder(
                          itemCount: selectedItems.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                selectedItems.elementAt(index),
                              ),
                              onTap: () {
                                setState(() {
                                  String item = selectedItems.elementAt(index);
                                  if (selectedItems.contains(item)) {
                                    selectedItems.remove(item);
                                  } else {
                                    selectedItems.add(item);
                                  }
                                });
                              },
                              selected: selectedItems
                                  .contains(selectedItems.elementAt(index)),
                            );
                          },
                        )
                      : FutureBuilder(
                          future: futureTitles,
                          builder: (context, snp) {
                            if (!snp.hasData ||
                                snp.connectionState != ConnectionState.done) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ListView.builder(
                              itemCount: snp.data!.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    snp.data!.elementAt(index),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      String item = snp.data!.elementAt(index);
                                      if (selectedItems.contains(item)) {
                                        selectedItems.remove(item);
                                      } else {
                                        selectedItems.add(item);
                                      }
                                    });
                                  },
                                  selected: selectedItems
                                      .contains(snp.data!.elementAt(index)),
                                );
                              },
                            );
                          },
                        ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: ElevatedButton(
                  onPressed: () {
                    if (_isSearch) {
                      setState(() {
                        _isSearch = false;
                      });
                    } else {
                      setState(() {
                        _isConfirm = false;
                      });
                    }
                  },
                  child: Text(
                    "Back",
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ),
            ),
            if (!_isSearch)
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_isConfirm) {
                        setState(() {
                          _isSearch = true;
                        });
                      } else {
                        setState(() {
                          _isConfirm = true;
                        });
                      }
                    },
                    child: Text(
                      "Next",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
