import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:aho_corasick/aho_corasick.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class CsvFileServices {
  static Stream<List<String>> search(String searchTerm) async* {
    var term = searchTerm.trim().toLowerCase();
    var files = await getExcelFiles();
    for (var file in files) {
      final lines = file.openRead().transform(utf8.decoder);
      await for (var line in lines) {
        var items = line.split(',');
        for (var item in items) {
          if (item.toLowerCase().contains(term)) {
            yield items;
            break;
          }
        }
        // Process your line here
      }
    }
    print("No row found for the search term");
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
