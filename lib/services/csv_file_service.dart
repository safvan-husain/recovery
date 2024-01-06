import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:aho_corasick/aho_corasick.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class CsvFileServices {
  static late String _searchTerm;
  static void search(String searchTerm,
      StreamController<Map<String, dynamic>> streamController) async {
    _searchTerm = searchTerm;
    try {
      var term = searchTerm.trim().toLowerCase();
      var files = await getExcelFiles();
      for (var file in files) {
        late List<String> titles;
        final reader = file.openRead();
        final decoder = utf8.decoder;
        var buffer = '';
        bool isTitleGot = false;
        await for (var data in reader) {
          if (streamController.isClosed || _searchTerm != searchTerm) {
            break;
          }
          buffer += decoder.convert(data);
          while (buffer.contains('\n')) {
            var lineEndIndex = buffer.indexOf('\n');
            var line = buffer.substring(0, lineEndIndex);

            var items = _splitStringIgnoringQuotes(line);

            if (!isTitleGot) {
              titles = items;
              isTitleGot = true;
            }
            if (items.length != titles.length) {
              // print(files.indexOf(file));
              // print(lines.indexOf(line));
              print(line);
              print(items);
              print(titles);
              throw ("item tiltle length mismatch: ${items.length}${titles.length}");
            }
            for (var item in items) {
              if (removeHyphens(item)
                  .toLowerCase()
                  .contains(removeHyphens(term))) {
                print("$item contain $term");
                Map<String, String> map = {};
                for (var i = 0; i < titles.length; i++) {
                  map[titles[i]] = items[i];
                }
                if (!streamController.isClosed) {
                  streamController.sink.add({"item": item, "row": map});
                }

                break;
              }
            }
            // Process your line here
            buffer = buffer.substring(lineEndIndex + 1);
          }
        }
      }
      streamController.sink.add({"item": "streamComplete", "row": {}});
    } catch (e) {
      print(e);
    }

    print("No row found for the search term");
  }

  static List<String> _splitStringIgnoringQuotes(String input) {
    List<String> result = [];
    bool insideQuotes = false;
    StringBuffer currentToken = StringBuffer();

    for (int i = 0; i < input.length; i++) {
      String char = input[i];

      if (char == '"') {
        insideQuotes = !insideQuotes;
        currentToken.write(char);
      } else if (char == ',' && !insideQuotes) {
        if (currentToken.toString().isEmpty) {
          result.add("");
        } else {
          result.add(currentToken.toString().trim());
        }

        currentToken.clear();
      } else {
        currentToken.write(char);
      }
    }

    // Add the last token
    result.add(currentToken.toString().trim());

    return result;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    var uuid = const Uuid();
    final dir = Directory('$path/vehicle details');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return File('$path/vehicle details/${uuid.v1()}.csv');
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<List<File>> getExcelFiles() async {
    final path = await _localPath;
    final directory = Directory('$path/vehicle details');
    if (await directory.exists()) {
      final files = directory.listSync();
      print("file length : ${files.length}");
      return files
          .where((file) => file.path.endsWith('.csv'))
          .toList()
          .whereType<File>()
          .toList();
    } else {
      print("No excel files found");
      return [];
    }
  }

  static Future<List<List<String>>> readCSVFromDocumentDir() async {
    List<List<String>> list = [];
    try {
      final files = await getExcelFiles();
      for (var file in files) {
        String contents = await file.readAsString();
        var rows = contents.split("\n");
        print("${file.path} have ${rows.length} rows");
        list.add(rows[1].split(","));
      }
      print(list[0].length);
    } catch (e) {
      print("readCSVFromDocumentDir" + e.toString());
    }
    return list;
  }

  static Future<void> copyAssetToDocumentDir() async {
    // Load the file from the assets folder
    ByteData byteData = await rootBundle.load('assets/icons/larger.csv');

    // Create a new file in the documents directory
    File file = await _localFile;

    // Write the contents of the loaded file to the new file
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }
}

String removeHyphens(String input) {
  return input.replaceAll('-', '');
}
