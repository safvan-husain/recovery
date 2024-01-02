import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

class JsonDataServices {
  static Future<Map<String, dynamic>> readJsonFromFileChunked() async {
    // final file = File(path);
    // final input = file.openRead();
    final input = await rootBundle.loadString('assets/icons/output.json');
    final decoder = utf8.decoder;
    const transformer = LineSplitter();

    // await for (var line in input.transform(decoder).transform(transformer)) {
    //   yield jsonDecode(line) as Map<String, dynamic>;
    // }
    for (var line in input.split('\n')) {
      print(line);
    }
    return {};
  }
}
