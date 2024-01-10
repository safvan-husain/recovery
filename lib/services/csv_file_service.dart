import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recovery_app/storage/database_helper.dart';
import 'package:uuid/uuid.dart';

class CsvFileServices {
  static Future<void> _proccessFiles([List<File>? csvFiles]) async {
    try {
      var files = csvFiles ?? await getExcelFiles();
      for (var file in files) {
        late List<String> titles;
        final reader = file.openRead();
        final decoder = utf8.decoder;
        var buffer = '';
        int? titleDBId;
        int? vehicalNumbrColumIndex;
        await for (var data in reader) {
          buffer += decoder.convert(data);
          while (buffer.contains('\n')) {
            var lineEndIndex = buffer.indexOf('\n');
            var line = buffer.substring(0, lineEndIndex);

            var items = _splitStringIgnoringQuotes(line);
            // .map((e) => removeHyphens(e))
            // .toList();

            if (titleDBId == null) {
              titles = items;
              if (titles.contains('veh_no')) {
                vehicalNumbrColumIndex = titles.indexOf('veh_no');
                titleDBId = await DatabaseHelper.inseartTitles(titles);
              } else {
                break;
              }
            } else {
              if (vehicalNumbrColumIndex != null) {
                await DatabaseHelper.inseartRow(
                    items, titleDBId, vehicalNumbrColumIndex);
              } else {
                break;
              }
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
    String fileName,
    void Function(int, int)? onReceiveProgress,
  ) async {
    Dio dio = Dio();
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String savePath = '${appDocDir.path}/vehicle details/$fileName';
      await dio.download(url, savePath, onReceiveProgress: (i, x) {});
    } catch (e) {
      print(e);
    }
  }

  static Future<void> _fetchDownloadLinksAndNames(
    String agencyId, [
    List<String> fileNames = const [],
  ]) async {
    String url = "https://converter.starkinsolutions.com/data";
    final dio = Dio();
    final response = await dio
        .post(url, data: {"filenames": fileNames, "agencyId": agencyId});

    if (response.statusCode == 200) {
      Map<String, String> downloadLinksAndNames = {};

      response.data['missingFiles'].forEach((link) {
        Uri uri = Uri.parse(link);
        String fileName = uri.pathSegments.last;
        downloadLinksAndNames[fileName] = link;
      });
      for (var i = 0; i < downloadLinksAndNames.entries.length; i++) {
        var map = downloadLinksAndNames.entries.toList().elementAt(i);
        await downloadFile(
            map.value.replaceAll('/home/starkina/', 'https://www.'), map.key,
            (received, total) {
          if (total != -1) {
            // print('${(received / total * 100).toStringAsFixed(0)}%');
          }
        });
      }
    } else {
      print('Failed to load download links');
      // throw Exception('Failed to load download links');
    }
  }

  static Future<void> updateData(String agencyId) async {
    var files = await getExcelFiles();
    List<String> fileNames =
        files.map((e) => basenameWithoutExtension(e.path)).toList();
    await _fetchDownloadLinksAndNames(agencyId, fileNames);

    files = await getExcelFiles();
    List<File> res = files
        .where((element) =>
            !fileNames.contains(basenameWithoutExtension(element.path)))
        .toList();
    await _proccessFiles(res);
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

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<void> deleteAllFilesInVehicleDetails() async {
    final path = await _localPath;
    final directory = Directory('$path/vehicle details');
    if (await directory.exists()) {
      final files = directory.listSync();
      for (var file in files) {
        if (file is File && file.path.endsWith('.csv')) {
          await file.delete();
        }
      }
    }
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

  static Future<void> copyAssetToDocumentDir() async {
    // Load the file from the assets folder
    ByteData byteData = await rootBundle.load('assets/icons/x.csv');

    // Create a new file in the documents directory
    // File file = await _localFile;

    // Write the contents of the loaded file to the new file
    // await file.writeAsBytes(byteData.buffer
    //     .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }
}

String removeHyphens(String input) {
  return input.replaceAll('-', '').replaceAll(' ', '').toLowerCase();
}
