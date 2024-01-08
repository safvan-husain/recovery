import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/screens/search/item_screen.dart';
import 'package:recovery_app/screens/search/widgets/searched_items_view.dart';
import 'package:recovery_app/services/csv_file_service.dart';
import 'package:flutter/foundation.dart';
import 'package:recovery_app/storage/database_helper.dart';

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
  bool _isSearchComplete = false;
  // List<FoundItem> items = [];
  final TextEditingController _controller = TextEditingController();
  final _streamController = StreamController<Map<String, dynamic>>();

  @override
  void initState() {
    super.initState();
  }

  List<String> items = [];
  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void addItemAndSort(List<Map<String, dynamic>> items,
      Map<String, dynamic> newItem, String target) {
    // Add the newItem to the list
    items.add(newItem);

    // Sort the list based on the proximity to the target
    items.sort((a, b) {
      // double distanceA = (a['item'] as String).compareTo(target).toDouble();
      // double distanceB = (b['item'] as String).compareTo(target).toDouble();
      int distanceA =
          levenshteinDistance(a['item'].toLowerCase(), target.toLowerCase());
      int distanceB =
          levenshteinDistance(b['item'].toLowerCase(), target.toLowerCase());
      return distanceA.compareTo(distanceB);
    });

    // Ensure the list length does not exceed
    if (items.length > 200) {
      items.removeLast();
    }
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
                items = value.isEmpty
                    ? []
                    : await DatabaseHelper.showForPrefix(removeHyphens(value));
                if (context.mounted) setState(() {});
              },
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: _isSearchComplete && items.isEmpty
            ? Center(
                child: Text("No search results for ${_controller.text}"),
              )
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      var result =
                          await DatabaseHelper.getDetails(items[index]);
                      print(result);
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (c) => ItemScreen(
                      //       details: items[index]['row'],
                      //       heroTag: 'item-$index',
                      //     ),
                      //   ),
                      // );
                    },
                    child: Hero(
                      tag: 'item-$index',
                      child: Card(
                        child: ListTile(
                          title: Text(items[index]),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

List<String> sortStrings(List<Map<String, dynamic>> items, String target) {
  List<String> result = items.map((item) => item['item'] as String).toList();
  int length = result.length;

  for (int width = 1; width < length; width *= 2) {
    for (int i = 0; i < length; i += 2 * width) {
      int from = i;
      int mid = i + width;
      int to = (i + 2 * width).clamp(0, length);

      merge(result, from, mid, to, target);
    }
  }

  return result;
}

void merge(List<String> array, int from, int mid, int to, String target) {
  List<String> merged = [];
  int i = from;
  int j = mid;

  while (i < mid && j < to) {
    if (compareLevenshteinDistance(array[i], target) <=
        compareLevenshteinDistance(array[j], target)) {
      merged.add(array[i]);
      i++;
    } else {
      merged.add(array[j]);
      j++;
    }
  }

  while (i < mid) {
    merged.add(array[i]);
    i++;
  }

  while (j < to) {
    merged.add(array[j]);
    j++;
  }

  for (int k = 0; k < merged.length; k++) {
    array[from + k] = merged[k];
  }
}

// The rest of the code remains unchanged

// List<Map<String, dynamic>> sortStrings(
//     List<Map<String, dynamic>> items, String target) {
//   return items
//     ..sort((a, b) => compareLevenshteinDistance(a['item'], target)
//         .compareTo(compareLevenshteinDistance(b['item'], target)))
//     ..map((item) => item['item'] as String).toList();
// }
int levenshteinDistance(String s, String t) {
  int lenS = s.length;
  int lenT = t.length;
  var matrix =
      List<List<int>>.generate(lenS + 1, (_) => List<int>.filled(lenT + 1, 0));

  for (var i = 0; i <= lenS; i++) {
    matrix[i][0] = i;
  }

  for (var j = 0; j <= lenT; j++) {
    matrix[0][j] = j;
  }

  for (var i = 1; i <= lenS; i++) {
    for (var j = 1; j <= lenT; j++) {
      var cost = s[i - 1] == t[j - 1] ? 0 : 1;
      matrix[i][j] = minOfThree(matrix[i - 1][j] + 1, matrix[i][j - 1] + 1,
          matrix[i - 1][j - 1] + cost);
    }
  }

  return matrix[lenS][lenT];
}

int minOfThree(int a, int b, int c) {
  return mins(mins(a, b), c);
}

int mins(int a, int b) {
  return a < b ? a : b;
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

// List<String> sortStrings(List<String> strings, String target) {
//   return strings
//     ..sort((a, b) => compareLevenshteinDistance(a, target)
//         .compareTo(compareLevenshteinDistance(b, target)));
// }

// int compareLevenshteinDistance(String s1, String s2) {
//   int len1 = s1.length;
//   int len2 = s2.length;
//   List<List<int>> matrix =
//       List.generate(len1 + 1, (_) => List<int>.filled(len2 + 1, 0));

//   for (var i = 0; i <= len1; i++) {
//     matrix[i][0] = i;
//   }
//   for (var j = 0; j <= len2; j++) {
//     matrix[0][j] = j;
//   }

//   for (var i = 1; i <= len1; i++) {
//     for (var j = 1; j <= len2; j++) {
//       var cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
//       matrix[i][j] = min([
//         matrix[i - 1][j] + 1,
//         matrix[i][j - 1] + 1,
//         matrix[i - 1][j - 1] + cost
//       ]);
//     }
//   }

//   return matrix[len1][len2];
// }

// int min(Iterable<int> numbers) {
//   int minNumber = numbers.first;
//   for (int number in numbers) {
//     if (number < minNumber) {
//       minNumber = number;
//     }
//   }
//   return minNumber;
// }
