import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';
import 'package:recovery_app/services/utils.dart';
import 'package:recovery_app/storage/database_helper.dart';
import 'package:recovery_app/storage/user_storage.dart';

class CsvFileServices {
  static Future<void> _proccessFiles(
    StreamController<Map<String, int>?> streamController,
    BuildContext context, [
    List<File>? csvFiles,
  ]) async {
    int count = 0;
    streamController.sink.add(null);
    List<String> titleList = ['VEHICAL NO']; //supported titles.
    var files = csvFiles ?? await getExcelFiles();
    int unreadFileIndex = await Storage.getProcessedFileIndex();
    for (var i = unreadFileIndex; i < files.length; i++) {
      List<List<String>> rows = [];
      var startTime = DateTime.now();
      streamController.sink.add(
          {"processing": Utils.calculatePercentage(i, files.length).toInt()});
      var file = files[i];
      late List<String> titles;
      final reader = file.openRead();
      final decoder = utf8.decoder;
      var buffer = '';
      int? titleDBId;
      int? vehicalNumbrColumIndex;
      bool found = false;
      await for (var data in reader) {
        buffer += decoder.convert(data);
        while (buffer.contains('\n')) {
          var lineEndIndex = buffer.indexOf('\n');
          var line = buffer.substring(0, lineEndIndex);

          var items = _splitStringIgnoringQuotes(line);
          items.add(basenameWithoutExtension(file.path));

          if (!found) {
            //TODO: vehivle column title.
            titles = items.map((e) => e.toLowerCase()).toList();

            for (var title in titleList) {
              if (titles.contains(title.toLowerCase())) {
                vehicalNumbrColumIndex = titles.indexOf(title.toLowerCase());
                found = true;
                break;
              }
            }
            if (!found) {
              break;
            }
          } else {
            if (vehicalNumbrColumIndex != null) {
              // await DatabaseHelper.inseartRow(items, vehicalNumbrColumIndex);
              if (rows.length < 1002) {
                rows.add(items);
              } else {
                await DatabaseHelper.bulkInsertVehicleNumbers(
                  rows,
                  titles,
                  vehicalNumbrColumIndex,
                );
                rows.clear();
                rows.add(items);
              }

              count++;
            } else {
              break;
            }
          }

          // Process your line here
          buffer = buffer.substring(lineEndIndex + 1);
        }
      }
      if (rows.isNotEmpty && found) {
        await DatabaseHelper.bulkInsertVehicleNumbers(
          rows,
          titles,
          vehicalNumbrColumIndex!,
        );
        rows.clear();
      }
      await Storage.addEntryCount(count);
      count = 0;
      await Storage.addProcessedFileIndex(i);
      var endTime = DateTime.now();
      var duration = endTime.difference(startTime);
      if (context.mounted) {
        log('updating estimated ');
        print(duration);
        context.read<HomeCubit>().updateEstimatedTime(
            duration.inMicroseconds * (files.length - unreadFileIndex));
      }
    }
    streamController.sink.add(null);
    // await Storage.addEntryCount(count);
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
    StreamController<Map<String, int>?> streamController, [
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
    } else {
      print('Failed to load download links');
      // throw Exception('Failed to load download links');
    }
  }

  static Future<void> updateData(
    String agencyId,
    StreamController<Map<String, int>?> streamController,
    BuildContext context,
  ) async {
    var files = await getExcelFiles();
    // getAndStoreTitles("2");
    List<String> fileNames =
        files.map((e) => basenameWithoutExtension(e.path)).toList();
    await _fetchDownloadLinksAndNames(agencyId, streamController, fileNames);

    files = await getExcelFiles();
    await _proccessFiles(
      streamController,
      context,
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
}
