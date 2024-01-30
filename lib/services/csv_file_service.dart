import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';
import 'package:recovery_app/services/utils.dart';
import 'package:recovery_app/storage/database_helper.dart';
import 'package:recovery_app/storage/user_storage.dart';

class CsvFileServices {
  static Future<void> _processFiles(
    StreamController<Map<String, int>?> streamController,
    HomeCubit homeCubit, [
    List<File>? csvFiles,
  ]) async {
    int count = 0;
    streamController.sink.add(null);
    var files = csvFiles ?? await getExcelFiles();
    // int readFileIndex = -1;
    // int readFileIndex = files.length - 2;
    int readFileIndex = await Storage.getProcessedFileIndex();
    if (readFileIndex == 0) readFileIndex = -1;
    //don't want to re process the last file if there is no new data (readFileIndex + 1).
    for (var i = readFileIndex + 1; i < files.length; i++) {
      List<List<String>> rows = [];
      var startTime = DateTime.now();
      streamController.sink.add(
          {"processing": Utils.calculatePercentage(i, files.length).toInt()});
      var file = files[i];

      late List<String> titles;
      final reader = file.openRead();
      final decoder = utf8.decoder;
      var buffer = '';
      int? vehicleNumberColumIndex;
      int? chassiNumberColumIndex;
      //for choosing whether to add to  .
      bool foundValidTitle = false;
      await for (var data in reader) {
        buffer += decoder.convert(data);
        while (buffer.contains('\n')) {
          var lineEndIndex = buffer.indexOf('\n');
          var line = buffer.substring(0, lineEndIndex);
          // print(line);

          var items = _splitStringIgnoringQuotes(line);
          //adding file name which contain info about finance and branch for adding it into the details.

          if (!foundValidTitle) {
            // count++;
            titles = items.map((e) => e.toLowerCase()).toList();

            if (titles.contains('VEHICAL NO'.toLowerCase()) ||
                titles.contains('vehicalno') ||
                titles.contains('vehicleno') ||
                titles.contains('vehicle no')) {
              vehicleNumberColumIndex =
                  titles.indexOf('VEHICAL NO'.toLowerCase());
              if (vehicleNumberColumIndex == -1) {
                vehicleNumberColumIndex = titles.indexOf('vehicalno');
              }
              if (vehicleNumberColumIndex == -1) {
                vehicleNumberColumIndex = titles.indexOf('vehicleno');
              }
              if (vehicleNumberColumIndex == -1) {
                vehicleNumberColumIndex = titles.indexOf('vehicle no');
              }

              foundValidTitle = true;
            } else if (titles.contains('CHASSIS NO'.toLowerCase())) {
              //only using in if whether find it or not, no use otherwise so random number.
              chassiNumberColumIndex = 0;
              foundValidTitle = true;
            }
            if (!foundValidTitle) {
              break;
            }
          } else {
            if (foundValidTitle &&
                items.where((element) => element.isNotEmpty).isNotEmpty) {
              while (items.length < titles.length) {
                items.add("");
              }
              items.add(basenameWithoutExtension(file.path));
              if (vehicleNumberColumIndex != null ||
                  chassiNumberColumIndex != null) {
                if (rows.length < 1002) {
                  rows.add(items);
                } else {
                  await DatabaseHelper.bulkInsertVehicleNumbers(
                    rows,
                    titles,
                    vehicleNumberColumIndex,
                  );
                  rows.clear();
                  rows.add(items);
                }
              } else {
                break;
              }
            }
            if (items.where((element) => element.isNotEmpty).isNotEmpty) {
              count++;
            }

            // if (items
            //     .map((e) => e.toLowerCase())
            //     .contains("gj-34-t-1421".toLowerCase())) {
            //   print("found that");
            //   log(items.toString());
            // }
          }

          // Process your line here
          buffer = buffer.substring(lineEndIndex + 1);
        }
      }
      if (rows.isNotEmpty && foundValidTitle) {
        await DatabaseHelper.bulkInsertVehicleNumbers(
          rows,
          titles,
          vehicleNumberColumIndex,
        );
        rows.clear();
      }
      homeCubit.updateDataCount(count);
      count = 0;
      await Storage.addProcessedFileIndex(i);
      var endTime = DateTime.now();
      var duration = endTime.difference(startTime);
      homeCubit
          .updateEstimatedTime(duration.inMicroseconds * (files.length - i));
    }
    streamController.sink.add(null);
  }

  static Future<void> _downloadFile(
    String url,
    String fileName,
    void Function(int, int)? onReceiveProgress,
  ) async {
    Dio dio = Dio();

    dio.options.headers['Connection'] = 'keep-alive';
    dio.options.headers['Accept-Encoding'] = 'gzip, deflate';
    dio.interceptors.add(InterceptorsWrapper(
      onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) async {
        options.headers['Connection'] = 'keep-alive';
        return handler.next(options); //continue
      },
    ));
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String savePath = '${appDocDir.path}/vehicle details/$fileName';
    await dio.download(url, savePath, onReceiveProgress: (i, x) {});
  }

  static Future<void> _fetchDownloadLinksAndNames(
    String agencyId,
    StreamController<Map<String, int>?> streamController,
    HomeCubit homeCubit, [
    List<String> fileNames = const [],
  ]) async {
    streamController.sink.add(null);
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
//getting deleted filenames from node server, then performing delete.
      List<String> deletedFiles = [];
      response.data['deleted'].forEach((fileName) {
        deletedFiles.add(fileName);
      });
      await deleteFiles(deletedFiles);

      homeCubit.reduceEntryCount(
        await DatabaseHelper.deleteDataInTheFiles(deletedFiles),
      );

      for (var i = 0; i < downloadLinksAndNames.entries.length; i++) {
        var map = downloadLinksAndNames.entries.toList().elementAt(i);
        await _downloadFile(
            map.value.replaceAll('/home/starkina/', 'https://www.'), map.key,
            (received, total) {
          if (total != -1) {
            // print('${(received / total * 100).toStringAsFixed(0)}%');
          }
        });
        streamController.sink.add({
          "Downloading": Utils.calculatePercentage(
                  i + 1, downloadLinksAndNames.entries.length)
              .toInt()
        });
      }
      await Storage.saveLastUpdatedTime();
    } else {
      print('Failed to load download links');
      // throw Exception('Failed to load download links');
    }
  }

  static Future<void> updateData(
    String agencyId,
    StreamController<Map<String, int>?> streamController,
    HomeCubit homeCubit,
  ) async {
    var files = await getExcelFiles();
    // getAndStoreTitles("2");
    List<String> fileNames =
        files.map((e) => basenameWithoutExtension(e.path)).toList();
    await _fetchDownloadLinksAndNames(
      agencyId,
      streamController,
      homeCubit,
      fileNames,
    );

    files = await getExcelFiles();
    await _processFiles(
      streamController,
      homeCubit,
      files,
    );
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

  static Future<void> deleteFiles(List<String> filenames) async {
    final path = await _localPath;
    final directory = Directory('$path/vehicle details');
    if (await directory.exists()) {
      final files = directory.listSync();
      for (var file in files) {
        var filenameWithoutExtension =
            file.path.split('/').last.split('.').first;
        if (filenames.contains(filenameWithoutExtension)) {
          await file.delete();
        }
      }
    } else {
      print("Directory does not exist");
    }
  }
}
