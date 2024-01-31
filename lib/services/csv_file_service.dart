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
    HomeCubit homeCubit,
    // List<File> csvFiles,
  ) async {
    int count = 0;
    streamController.sink.add(null);
    var files = await getExcelFiles();

    // int readFileIndex = 0 try;
    int readFileIndex = await Storage.getProcessedFileIndex();
    // if (readFileIndex == 0) readFileIndex = -1;
    //don't want to re process the last file if there is no new data (readFileIndex + 1).
    print("starting with ${readFileIndex + 1} of ${files.length}");
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
          // log(items.toString());
          if (!foundValidTitle) {
            log("on not found title : ${basenameWithoutExtension(file.path)}");
            // count++;
            titles = items;
            titles = items.map((e) => e.replaceAll(".", "")).toList();
            log(titles.toString());
            foundValidTitle = true;
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
            }
          } else {
            // count++;
            // if (items.where((element) => element.isNotEmpty).isNotEmpty) {
            while (items.length < titles.length) {
              items.add("");
            }
            print(basenameWithoutExtension(file.path));
            items.add(basenameWithoutExtension(file.path));
            rows.add(items);
            // if (rows.length < 1052) {
            // } else {
            //   rows.add(items);
            //   await DatabaseHelper.bulkInsertVehicleNumbers(
            //     rows,
            //     titles,
            //     vehicleNumberColumIndex,
            //   );
            //   rows.clear();
            // }
            // }
          }

          // Process your line here
          buffer = buffer.substring(lineEndIndex + 1);
        }
      }
      if (rows.isNotEmpty) {
        count += rows.length;
        await DatabaseHelper.bulkInsertVehicleNumbers(
          rows,
          titles,
          vehicleNumberColumIndex,
        );
        rows.clear();
      }
      await Storage.setProcessedFileIndex(i);
      var endTime = DateTime.now();
      var duration = endTime.difference(startTime);
      homeCubit
          .updateEstimatedTime(duration.inMicroseconds * (files.length - i));
    }
    print("lines $count");
    homeCubit.updateDataCount();
    streamController.sink.add(null);
  }

  static Future<String> _downloadFile(
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
    return savePath;
  }

  static Future<List<String>> _fetchDownloadLinksAndNames(
    String agencyId,
    StreamController<Map<String, int>?> streamController,
    HomeCubit homeCubit, [
    List<String> fileNames = const [],
  ]) async {
    List<String> downloadedPaths = [];
    streamController.sink.add(null);
    String url = "https://converter.starkinsolutions.com/data";
    final dio = Dio();
    final response = await dio.post(url,
        data: jsonEncode({
          "filenames": fileNames
              .map((e) {
                var array = e.split("______");
                return [array[0], array[1], array[2]].join("______");
              })
              .toSet()
              .toList(),
          "agencyId": agencyId,
        }));
    print(response);
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

      print(deletedFiles);
      await DatabaseHelper.deleteDataInTheFiles(deletedFiles);
      homeCubit.updateDataCount();

      for (var i = 0; i < downloadLinksAndNames.entries.length; i++) {
        var map = downloadLinksAndNames.entries.toList().elementAt(i);
        String downloadedPath = await _downloadFile(
            map.value.replaceAll('/home/starkina/', 'https://www.'), map.key,
            (received, total) {
          if (total != -1) {
            // print('${(received / total * 100).toStringAsFixed(0)}%');
          }
        });
        downloadedPaths.add(downloadedPath);
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
    return downloadedPaths;
  }

  static Future<void> updateData(
    String agencyId,
    StreamController<Map<String, int>?> streamController,
    HomeCubit homeCubit,
  ) async {
    print("updateData called");
    var files = await getExcelFiles();
    print("file length : ${files.length}");
    List<String> fileNames =
        files.map((e) => basenameWithoutExtension(e.path)).toList();
    var downloadedPaths = await _fetchDownloadLinksAndNames(
      agencyId,
      streamController,
      homeCubit,
      fileNames,
    );

    // files = await getExcelFiles();
    await _processFiles(
      streamController,
      homeCubit,
      // downloadedPaths.map((e) => File(e)).toList(),
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
          .toList()
        //sorting to get the last added file at the last of the array.
        ..sort(
            (a, b) => a.statSync().modified.compareTo(b.statSync().modified));
    } else {
      print("No excel files found");
      return [];
    }
  }

  static Future<void> deleteFiles(List<String> filenames) async {
    print(filenames);
    final path = await _localPath;
    final directory = Directory('$path/vehicle details');
    int deletingFileCount = 0;
    if (await directory.exists()) {
      final files = directory.listSync();
      for (var file in files) {
        var fileNamwBankBranch =
            file.path.split('/').last.split('.').first.split("______");
        var filenameWithoutExtension = [
          fileNamwBankBranch[0],
          fileNamwBankBranch[1],
          fileNamwBankBranch[2]
        ].join("______");
        print(filenameWithoutExtension);
        if (filenames.contains(filenameWithoutExtension)) {
          await file.delete();
          deletingFileCount++;
          int currentCount =
              await Storage.getProcessedFileIndex() - deletingFileCount;
          await Storage.setProcessedFileIndex(
              currentCount < 0 ? -1 : currentCount);
        }
      }
    } else {
      print("Directory does not exist");
    }
  }
}
