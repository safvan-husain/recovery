import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recovery_app/storage/database_helper.dart';
import 'package:uuid/uuid.dart';

class CsvFileServices {
  static void proccessFiles() async {
    try {
      var files = await getExcelFiles();
      for (var file in files) {
        late List<String> titles;
        final reader = file.openRead();
        final decoder = utf8.decoder;
        var buffer = '';
        int? titleDBId;
        await for (var data in reader) {
          buffer += decoder.convert(data);
          while (buffer.contains('\n')) {
            var lineEndIndex = buffer.indexOf('\n');
            var line = buffer.substring(0, lineEndIndex);

            var items = _splitStringIgnoringQuotes(line)
                .map((e) => removeHyphens(e))
                .toList();

            if (titleDBId == null) {
              titles = items;
              titleDBId = await DatabaseHelper.inseartTitles(titles);
            } else {
              await DatabaseHelper.inseartRow(items, titleDBId);
            }

            // Process your line here
            buffer = buffer.substring(lineEndIndex + 1);
          }
        }
      }
    } catch (e) {
      print(e);
    }

    print("No row found for the search term");
  }

  static Future<void> downloadFile(
    String url,
    String savePath,
    StreamController<double> downloadProgress,
  ) async {
    Dio dio = Dio();
    try {
      await dio.download(url, savePath, onReceiveProgress: (received, total) {
        if (total != -1) {
          print('${(received / total * 100).toStringAsFixed(0)}%');
        }
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<Map<String, String>> fetchDownloadLinksAndNames(
    String agencyId,
    StreamController<double> downloadProgress,
  ) async {
    String url = "http://192.168.43.32:3000/data";
    final dio = Dio();
    final response =
        await dio.post(url, data: {"filenames": [], "agencyId": agencyId});

    if (response.statusCode == 200) {
      Map<String, String> downloadLinksAndNames = {};

      response.data['missingFiles'].forEach((link) {
        Uri uri = Uri.parse(link);
        String fileName = uri.pathSegments.last;
        downloadLinksAndNames[fileName] = link;
      });
      downloadLinksAndNames.forEach((key, value) async {
        await downloadFile(value, key, downloadProgress);
      });
      return downloadLinksAndNames;
    } else {
      throw Exception('Failed to load download links');
    }
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
    ByteData byteData = await rootBundle.load('assets/icons/x.csv');

    // Create a new file in the documents directory
    File file = await _localFile;

    // Write the contents of the loaded file to the new file
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }
}

String removeHyphens(String input) {
  return input.replaceAll('-', '').replaceAll(' ', '').toLowerCase();
}
