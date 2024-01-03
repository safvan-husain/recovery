import 'dart:io';

import 'package:flutter/services.dart';
import 'package:aho_corasick/aho_corasick.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class CsvFileServices {
  static Future<List<List<String>>> test() async {
    print("started processing");
    List<List<String>> list = [];
    try {
      final input = await rootBundle.loadString('assets/icons/large.csv');
      var rows = input.split("\n").map((i) => i.split(",")).toList();
      for (var row in rows) {
        for (var element in row) {
          if (element.contains('KL47H061')) {
            print(row);
          }
        }
      }
      print("proccssing complete");
    } catch (e) {
      print(e);
    }
    return list;
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
        list.add(rows[1].split(","));
      }
    } catch (e) {
      print("readCSVFromDocumentDir" + e.toString());
    }
    return list;
  }

  static Future<void> copyAssetToDocumentDir() async {
    // Load the file from the assets folder
    ByteData byteData = await rootBundle.load('assets/icons/large.csv');

    // Create a new file in the documents directory
    File file = await _localFile;

    // Write the contents of the loaded file to the new file
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }
}
