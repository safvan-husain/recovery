import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recovery_app/models/detail_model.dart';
import 'package:excel/excel.dart';

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

  static Future<void> getAllTables() async {}

  static Future<List<DetailsModel>> getVehichalMapList() async {
    List<DetailsModel> vehicles = [];
    List<Excel> excels = await getExcelFiles();
    log("number of excels: " + excels.length.toString());
    if (excels.isEmpty) return vehicles;
    var excel = excels[0];
    // for (var table in excel.tables.keys) {
    bool isGotIndex = false;
    int? customerNameColumnIndex;
    int? vehichakNumberColumnIndex;
    int? EngineNoColumnIndex;
    int? agreementNumberColumnIndex;
    int? manufectureColumnIndex;
    int? yearManfuColumnIndex;
    int? vehichelModelColumnIndex;
    int? zoneColumnIndex;
    int? subZoneColumnIndex;
    int? regionColumnIndex;
    int? areaColumnIndex;
    int? emiStartDateColumnIndex; //
    int? emiLastDateColumnIndex; //
    int? paidTnerGrpColumnIndex; //
    int? cifNumberColumnIndex; //
    int? branchColumnIndex; //
    int? subProductionColumnIndex;
    int? modelManufactiorColumnIndex; //
    for (var row in excel.tables["Sheet1"]!.rows) {
      //a single vehichel details.
      // List<String> values = row.map((e) => e!.value.toString()).toList();

      if (isGotIndex) {
        if (subProductionColumnIndex != null) {
          FilterValues.addCatValue(
              row[subProductionColumnIndex]!.value.toString());
        } else {
          print("found a row without sub production column");
        }
        if (areaColumnIndex != null) {
          FilterValues.addAreaValue(row[areaColumnIndex]!.value.toString());
        } else {
          print("found a row without area column");
        }
        vehicles.add(
          DetailsModel(
            // engineNo: "",
            engineNo: EngineNoColumnIndex == null
                ? ""
                : row[EngineNoColumnIndex]!.value.toString(),
            name: customerNameColumnIndex == null
                ? ""
                : row[customerNameColumnIndex]!.value.toString(),
            vehicalNo: vehichakNumberColumnIndex == null
                ? ""
                : row[vehichakNumberColumnIndex]!.value.toString(),
            manufecture: manufectureColumnIndex == null
                ? ""
                : row[manufectureColumnIndex]!.value.toString(),
            cifNumber: cifNumberColumnIndex == null
                ? ""
                : row[cifNumberColumnIndex]!.value.toString(),
            yearManfu: yearManfuColumnIndex == null
                ? ""
                : row[yearManfuColumnIndex]!.value.toString(),
            modelManufactior: modelManufactiorColumnIndex == null
                ? ""
                : row[modelManufactiorColumnIndex]!.value.toString(),
            branch: branchColumnIndex == null
                ? ""
                : row[branchColumnIndex]!.value.toString(),
            subProduction: subProductionColumnIndex == null
                ? ""
                : row[subProductionColumnIndex]!.value.toString(),
            zone: zoneColumnIndex == null
                ? ""
                : row[zoneColumnIndex]!.value.toString(),
            subZone: subZoneColumnIndex == null
                ? ""
                : row[subZoneColumnIndex]!.value.toString(),
            region: regionColumnIndex == null
                ? ""
                : row[regionColumnIndex]!.value.toString(),
            emiStartDate: emiStartDateColumnIndex == null
                ? ""
                : row[emiStartDateColumnIndex]!.value.toString(),
            emiLastDate: emiLastDateColumnIndex == null
                ? ""
                : row[emiLastDateColumnIndex]!.value.toString(),
            agreementNumber: agreementNumberColumnIndex == null
                ? ""
                : row[agreementNumberColumnIndex]!.value.toString(),
            paidTnerGrp: paidTnerGrpColumnIndex == null
                ? ""
                : row[paidTnerGrpColumnIndex]!.value.toString(),
            area: areaColumnIndex == null
                ? ""
                : row[areaColumnIndex]!.value.toString(),
            // vehichelModel: row[vehichelModelColumnIndex!]!.value.toString(),
          ),
        );
      } else {
        isGotIndex = true;
        for (var i = 0; i < row.length; i++) {
          switch (row[i]!.value.toString()) {
            case "REGDNUM":
              vehichakNumberColumnIndex = i;
              break;
            case "CUSTOMERNAME":
              customerNameColumnIndex = i;
              break;
            case "ENGINENUM":
              EngineNoColumnIndex = i;
              break;
            case "CATGDESC REV":
              subProductionColumnIndex = i;
              break;
            case "AGREEMENTNO":
              agreementNumberColumnIndex = i;
              break;
            case "CIF_NO":
              cifNumberColumnIndex = i;
              break;
            case "ZONE":
              zoneColumnIndex = i;
              break;
            case "SUB ZONE":
              subZoneColumnIndex = i;
              break;
            case "REGION":
              regionColumnIndex = i;
              break;

            case "AREA":
              areaColumnIndex = i;
              break;
            case "BRANCH":
              branchColumnIndex = i;
              break;
            case "EMI_STARTDATE":
              emiStartDateColumnIndex = i;
              break;
            case "LAST_EMI_DATE":
              emiLastDateColumnIndex = i;
              break;
            case "PAID TENURE GRP":
              paidTnerGrpColumnIndex = i;
              break;
            case "MANUFACTURERDESC":
              manufectureColumnIndex = i;
              break;
            case "YEAR_OF_MANF":
              yearManfuColumnIndex = i;
              break;
            case "MODEL_NO":
              modelManufactiorColumnIndex = i;
              break;

            default:
          }
        }
      }
    }
    return vehicles;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    var uuid = Uuid();
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
      print("vehcal directory not found");
      return [];
    }
  }

  static Future<StreamController<double>> downloadFile(String url) async {
    final progressController = StreamController<double>();
    Permission permission = Permission.storage;
    if (await permission.request().isGranted) {
      Dio dio = Dio();
      try {
        File file = await _localFile;
        var res = dio.download(
          url,
          file.path,
          onReceiveProgress: (count, total) {
            double progress = (count / total) * 100;
            progressController.sink.add(progress);
          },
        );
      } catch (e) {
        print(e);
      }
    } else {
      // Permission denied
    }
    return progressController;
  }

  Future<File> writeCounter(Excel excel) async {
    final file = await _localFile;
    return file.writeAsBytes(excel.encode()!);
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // static Future<void> downloadAndStore(void Function() afterStore) async {
  //   ByteData data = await rootBundle.load("assets/icons/data.xlsx");
  //   await store(
  //     Excel.decodeBytes(
  //       data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
  //     ),
  //   );
  //   afterStore();
  // }

  static Future<void> store(Excel excel) async {
    Permission permission = Permission.storage;
    if (await permission.request().isGranted) {
      var fileBytes = excel.save();
      var directory = await getApplicationDocumentsDirectory();
      var uuid = Uuid();
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
