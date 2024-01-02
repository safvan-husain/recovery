import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recovery_app/models/detail_model.dart';
import 'package:excel/excel.dart';
import 'package:archive/archive_io.dart';

class FoundItem {
  final String item;
  final int excelIndex;
  final String sheet;
  final int row;

  FoundItem(this.item, this.excelIndex, this.sheet, this.row);
}

class FilterValues {
  // final _instance = FilterValues._internal();
  // FilterValues._internal();
  // FilterValues get instance => _instance;
  static Set<String> catValues = {};
  static Set<String> areaValues = {};

  static void addCatValue(String value) {
    catValues.add(value);
  }

  static void addAreaValue(String value) {
    areaValues.add(value);
  }
}

class ExcelStore {
  static Future<void> initilize() async {
    // ByteData data = await rootBundle.load("assets/icons/data.xlsx");
    // bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await deleteAllFiles();
  }

  static var values = Set<String>();

  static Future<Map<String, List<String>>> getFilterValueObject({
    required String catTitle,
    required String areaTitle,
  }) async {
    List<String> catValues = [];
    List<String> areaValues = [];
    var excelFiles = await getExcelFiles();
    for (var m = 0; m < excelFiles.length; m++) {
      var excelFile = excelFiles[m];
      int? catIndex;
      int? areaIndex;
      for (var i = 0; i < excelFile.tables["Sheet1"]!.rows.length; i++) {
        var element = excelFile.tables["Sheet1"]!.rows[i];
        if (i == 0) {
          for (var j = 0; j < element.length; j++) {
            if (element[j]!.value.toString() == catTitle) {
              catIndex = j;
            } else if (element[j]!.value.toString() == areaTitle) {
              areaIndex = j;
            }
          }
          if (catIndex == null || areaIndex == null) {
            print("not able to find column index for cat or area index");
            break;
          }
        } else {
          catValues.add(element[catIndex!]!.value!.toString());
          areaValues.add(element[areaIndex!]!.value!.toString());
        }
      }
      print(catValues.toSet().toList());
    }
    return {"category": catValues, "Area": areaValues};
  }

  static List<DetailsModel> filtered(
    List<DetailsModel> list, [
    String? areaValue,
    String? subProduct,
  ]) {
    return list.where((element) {
      bool isAreaValid = areaValue == null || areaValue == element.area;
      bool isSubProductValid =
          subProduct == null || subProduct == element.subProduction;

      return isAreaValid && isSubProductValid;
    }).toList();
  }

  static Future<Map<String, String>> getRowItems(FoundItem foundItem) async {
    Map<String, String> map = {};
    List<Excel> excels = await getExcelFiles();
    List<String> keys = excels[foundItem.excelIndex][foundItem.sheet]
        .rows[0]
        .map((e) => e!.value.toString())
        .toList();

    List<String> values = excels[foundItem.excelIndex][foundItem.sheet]
        .rows[foundItem.row]
        .map((e) => e!.value.toString())
        .toList();
    for (var i = 0; i < keys.length; i++) {
      map[keys[i]] = values[i];
    }
    return map;
  }

  static Future<List<FoundItem>> searchItems(
    List<String> titles,
    String searchString,
  ) async {
    List<FoundItem> foundItems = [];
    List<Excel> excels = await getExcelFiles();
    for (var i = 0; i < excels.length; i++) {
      var excelFile = excels[i];
      for (var sheet in excelFile.sheets.values) {
        var titleRow = sheet.rows[0];
        for (var rowIndex = 1; rowIndex < sheet.rows.length; rowIndex++) {
          var row = sheet.rows[rowIndex];
          for (var title in titles) {
            var titleIndex = titleRow
                .map((e) => e!.value.toString())
                .toList()
                .indexOf(title);
            if (titleIndex != -1 &&
                row[titleIndex]!.value.toString().contains(searchString)) {
              foundItems.add(FoundItem(row[titleIndex]!.value.toString(), i,
                  sheet.sheetName, rowIndex));
            }
          }
        }
      }
    }
    print(foundItems.map((e) => e.item).toList());
    return foundItems;
  }

  static Future<List<String>> getAllTitles() async {
    List<Excel> excels = await getExcelFiles();
    List<String> titilesList = [];
    for (var i = 0; i < excels.length; i++) {
      //inside an excel file.
      for (var sheet in excels[i].sheets.values) {
        // Get the first row of the sheet, which should contain the titles.
        var titles = sheet.rows[0];
        for (var element in titles) {
          titilesList.add(element!.value.toString());
        }
        // Print the titles.
        // print(titles.map((e) => e!.value.toString()).length);
      }
    }
    return titilesList;
  }

  static Future<void> processFile(File file) async {
    try {
      // Open the file for reading
      Stream<List<int>>? fileSink = file.openRead();

      // Stream to read the file content chunk by chunk
      await for (List<int> chunk in fileSink) {
        print("read a chunk of content");
        // TODO: Process the chunk as needed
        String chunkString = utf8.decode(chunk);

        // TODO: Process the chunkString as needed
        print(chunkString);
      }
      fileSink = null;
    } catch (e) {
      print('Error processing file: $e');
    }
  }

  static void test() async {
    try {
      var files = await getFiles();
      for (File file in files) {
        print("${file.path} proccessing started");
        await processFile(file);
      }
      log("processing complete");
    } catch (e) {
      print(e);
    }
  }

  static Future<List<List<String?>>> getAllListSheetTitles(
      List<File> files) async {
    List<List<String?>> titilesList = [];
    for (var i = 0; i < files.length; i++) {
      print("file current length : ${i} : ${files[i].path}");
      Excel? excel = Excel.decodeBytes(
        files[i].readAsBytesSync(),
      );
      //inside an excel file.
      for (var sheet in excel.sheets.values) {
        // Get the first row of the sheet, which should contain the titles.
        var titles = sheet.rows[0];
        titilesList
            .add(titles.map((element) => element?.value.toString()).toList());
      }
      excel = null;
    }
    return titilesList;
  }

  static Future<List<DetailsModel>> getVehichalMapList() async {
    List<DetailsModel> vehicles = [];

    return vehicles;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    var uuid = const Uuid();
    return File('$path/vehicle details/${uuid.v1()}.xlsx');
  }

  static Future<List<Excel>> getExcelFiles() async {
    final path = await _localPath;
    final directory = Directory('$path/vehicle details');
    if (await directory.exists()) {
      final files = directory.listSync();
      log("file length : ${files.length}");
      return files
          .where((file) => file.path.endsWith('.xlsx'))
          .toList()
          .whereType<File>()
          .toList()
          .map(
        (e) {
          log("a file found at : ${e.path}");
          return Excel.decodeBytes(
            e.readAsBytesSync(),
          );
        },
      ).toList();
    } else {
      print("No excel files found");
      return [];
    }
  }

  static Future<List<File>> getFiles() async {
    final path = await _localPath;
    final directory = Directory('$path/vehicle details');
    if (await directory.exists()) {
      final files = directory.listSync();
      log("file length : ${files.length}");
      return files
          .where((file) => file.path.endsWith('.xlsx'))
          .toList()
          .whereType<File>()
          .toList();
    } else {
      print("No excel files found");
      return [];
    }
  }

  static Future<void> downloadFile(
      String agencyId, StreamController<double> progressController) async {
    Permission permission = Permission.storage;
    if (await permission.request().isGranted) {
      Dio dio = Dio();
      dio.options.connectTimeout = Duration(seconds: 5); //5s
      dio.options.receiveTimeout = Duration(seconds: 5); //5s;
      try {
        var response = await dio.post(
          "https://www.recovery.starkinsolutions.com/downloadapi.php",
          data: {"admin_id": agencyId},
        );
        print("After response : ${response.statusCode}");
        if (response.statusCode == 200) {
          List decodedResponse = jsonDecode(response.data);
          double totalProgress = 0.0;
          for (var i = 0; i < decodedResponse.length; i++) {
            var element = decodedResponse.elementAt(i);
            var url =
                "https://www.recovery.starkinsolutions.com/${element["bank_report"]}";

            try {
              File file = await _localFile;
              var res = await dio.download(
                url,
                file.path,
                onReceiveProgress: (count, total) {
                  double fileProgress = (count / total);
                  totalProgress =
                      ((i + fileProgress) / decodedResponse.length) * 100;
                  progressController.sink.add(totalProgress);
                },
              );
            } catch (e) {
              print(e);
            }
          }
        }
      } catch (e) {
        print(e);
      }
    } else {
      // Permission denied
    }
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<void> store(Excel excel) async {
    Permission permission = Permission.storage;
    if (await permission.request().isGranted) {
      var fileBytes = excel.save();
      var directory = await getApplicationDocumentsDirectory();
      var uuid = const Uuid();
      var file =
          File(join('${directory.path}/vehicle details/${uuid.v1()}.xlsx'))
            ..createSync(recursive: true)
            ..writeAsBytesSync(fileBytes!);
      log("file saved on : ${file.path}");
      // Permission granted
    } else {
      log("permission denied");
      // Permission denied
    }
  }

  static Future<void> deleteAllFiles() async {
    var directory = await getApplicationDocumentsDirectory();
    final dirPath = '${directory.path}/vehicle details';

    final dir = Directory(dirPath);

    if (await dir.exists()) {
      dir.listSync().forEach((file) {
        if (file is File) {
          file.deleteSync();
        }
      });
    }
  }
}
