// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:path/path.dart';
import 'package:recovery_app/storage/user_storage.dart';
import 'package:sqflite/sqflite.dart';

import 'package:recovery_app/services/utils.dart';
import 'package:recovery_app/models/search_item_model.dart';

class DatabaseHelper {
  static late final Database _database;
  static var tableVehicleInfo = 'trie';
  static var last4digitVehicleNumber = 'Number';
  static String chessiNo = "chessiNo";

  static Future<void> initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'your_database.db'),
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $tableVehicleInfo (
  id INTEGER PRIMARY KEY,
  $last4digitVehicleNumber TEXT,
  completeVehicleNumber TEXT,
  $chessiNo TEXT,
  details TEXT,
  fileName TEXT
)''');
      },
      version: 1,
    );
  }

  static Future<void> deleteAllData() async {
    await _database.delete(tableVehicleInfo);
  }

  static Future<void> bulkInsertVehicleNumbers(
    List<List<String>> rows,
    List<String> titles,
    int? vehicleNumberColumIndex,
  ) async {
    var batch = _database.batch();
    for (var row in rows) {
      await _insertRow(
        row,
        titles,
        vehicleNumberColumIndex,
        batch,
      );
    }
    await batch.commit();
  }

  static Future<void> _insertRow(
    List<String> row,
    List<String> titles,
    int? vehicleNumberColumIndex,
    Batch batch,
  ) async {
    if (vehicleNumberColumIndex != null) {
      var s = Utils.removeHyphens(row.elementAt(vehicleNumberColumIndex));

      var res = Utils.checkLastFourChars(s);
      if (res.$1) {
        await _insertString(res.$2, row, titles, s, batch);
      }
    } else {
      await _insertString('', row, titles, '', batch);
    }
  }

  static Future<void> _insertString(
    String word,
    List<String> row,
    List<String> titles,
    String completeVehicleNumber,
    Batch batch,
  ) async {
    var details = {};
    try {
      for (var i = 0; i < titles.length; i++) {
        details[titles[i]] = row[i];
      }
    } catch (e) {
      print("error at database helper inseart string titles ${titles.length}");
      print("rows ${row.length}");
      // rethrow;
    }

    //row.last is the filename given from the server, it contain information about finance and branch.
    List<String> content = row.last.split("______");
    details["file name"] = content[0];
    details["finance"] = content[1];
    details["branch"] = content[2];
    batch.insert(
      tableVehicleInfo,
      {
        last4digitVehicleNumber: word,
        "completeVehicleNumber": completeVehicleNumber,
        chessiNo: details['CHASSIS NO'.toLowerCase()] ?? "",
        'details': jsonEncode(details),
        "fileName": content[0],
      },
    );
  }

  static Future<List<SearchResultItem>> getResult(
    String number, [
    bool isVehicle = true,
  ]) async {
    List<SearchResultItem> list = [];
    var results = await _database.query(
      tableVehicleInfo,
      where: isVehicle ? '$last4digitVehicleNumber = ?' : '$chessiNo = ?',
      whereArgs: [isVehicle ? number : number.toUpperCase()],
    );
    print(number);
    print(results);
    if (results.isNotEmpty) {
      for (var element in results) {
        var details = jsonDecode(element['details'] as String);
        Map<String, String> stringDetails = {};

        details.forEach((key, value) {
          // Ensure that each value is a string before adding it to the new map
          stringDetails[key] = value.toString();
        });
        list.add(
          SearchResultItem(
            item: isVehicle
                ? element['completeVehicleNumber'] as String
                : element['chessiNo'] as String? ?? "chass miss",
            rows: [stringDetails],
          ),
        );
      }
    }
    return SearchResultItem.mergeDuplicateItems(list);
  }

  static Future<List<BankBranch>> getBranches(
      List<Map<String, String>> rows) async {
    List<BankBranch> branches = [];
    for (var element in rows) {
      try {
        branches.add(
          BankBranch(
            bank: element['finance'] ?? "",
            branch: element['branch'] ?? "",
            fileName: element['file name'] ?? "",
          ),
        );
      } catch (e) {
        print(e);
      }
    }
    // return [];
    return branches;
  }

  ///delete sqlite data that have these file names and return deleted count.
  static Future<void> deleteDataInTheFiles(
    List<String> fileNameWithExtensionAndBankBranchNames,
  ) async {
    var batch = _database.batch();

    for (var file in fileNameWithExtensionAndBankBranchNames) {
      String fileName = file.split("______").first;
      batch.delete(
        tableVehicleInfo,
        where: "fileName = ?",
        whereArgs: [fileName],
      );
    }
    await batch.commit();
  }

  static Future<int> getTotalEntries() async {
    var result =
        await _database.rawQuery('SELECT COUNT(*) FROM $tableVehicleInfo');
    return result.first['COUNT(*)'] as int;
  }
}

class BankBranch {
  final String bank;
  final String branch;
  final String fileName;
  BankBranch({
    required this.bank,
    required this.branch,
    required this.fileName,
  });
}
