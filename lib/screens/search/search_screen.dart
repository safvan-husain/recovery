import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/screens/search/item_screen.dart';
import 'package:recovery_app/screens/search/widgets/searched_items_view.dart';
import 'package:recovery_app/services/csv_file_service.dart';
import 'package:recovery_app/services/excel_store.dart';
import 'package:flutter/foundation.dart';

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
  // List<FoundItem> items = [];
  final TextEditingController _controller = TextEditingController();
  final _streamController = StreamController<Map<String, dynamic>>();

  @override
  void initState() {
    _streamController.stream.listen((event) {
      items.add(event);
      setState(() {});
    });
    super.initState();
  }

  List<Map<String, dynamic>> items = [];
  @override
  void dispose() {
    _streamController.close();
    super.dispose();
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
          title: Container(
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
                CsvFileServices.search(_controller.text, _streamController);
                items = [];
                setState(() {});
              },
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (c) => ItemScreen(details: items[index]['row']),
                  ),
                );
              },
              child: ListTile(
                title: Text(items[index]['item']),
              ),
            );
          },
        ),
      ),
    );
  }
}

List<String> sortStrings(List<String> strings, String target) {
  return strings
    ..sort((a, b) => compareLevenshteinDistance(a, target)
        .compareTo(compareLevenshteinDistance(b, target)));
}

int compareLevenshteinDistance(String s1, String s2) {
  int len1 = s1.length;
  int len2 = s2.length;
  List<List<int>> matrix =
      List.generate(len1 + 1, (_) => List<int>.filled(len2 + 1, 0));

  for (var i = 0; i <= len1; i++) {
    matrix[i][0] = i;
  }
  for (var j = 0; j <= len2; j++) {
    matrix[0][j] = j;
  }

  for (var i = 1; i <= len1; i++) {
    for (var j = 1; j <= len2; j++) {
      var cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
      matrix[i][j] = min([
        matrix[i - 1][j] + 1,
        matrix[i][j - 1] + 1,
        matrix[i - 1][j - 1] + cost
      ]);
    }
  }

  return matrix[len1][len2];
}

int min(Iterable<int> numbers) {
  int minNumber = numbers.first;
  for (int number in numbers) {
    if (number < minNumber) {
      minNumber = number;
    }
  }
  return minNumber;
}
