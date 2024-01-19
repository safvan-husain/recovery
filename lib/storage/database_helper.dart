// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:recovery_app/services/csv_file_service.dart';
import 'package:recovery_app/services/utils.dart';
import 'package:recovery_app/storage/node_model.dart';

class DatabaseHelper {
  // DatabaseHelper._internal();
  static late final Database _database;
  static var jsonStore = 'json_store';
  static var trie = 'trie';
  static var charColum = 'charecter';

  static Future<void> initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'your_database.db'),
      onCreate: (db, version) async {
        // Create your tables here
        await db.execute(
            'CREATE TABLE $jsonStore (id INTEGER PRIMARY KEY, json_string TEXT, titleId INTEGER)');
        await db.execute('''CREATE TABLE $trie (
  id INTEGER PRIMARY KEY,
  $charColum TEXT,
  og TEXT
)''');
      },
      version: 1,
    );
  }

  static Future<void> deleteAllData() async {
    await _database.delete(jsonStore);
    await _database.delete(trie);
  }

  static Future<int> inseartTitles(
    List<String> titles,
  ) async {
    return await _database
        .insert(jsonStore, {'json_string': jsonEncode(titles)});
  }

  static Future<void> inseartRow(
    List<String> row,
    int titlesId,
    int vehicalNumbrColumIndex,
  ) async {
    int rowId = await _database.insert(
        jsonStore, {'json_string': jsonEncode(row), 'titleId': titlesId});
    var s = Utils.removeHyphens(row.elementAt(vehicalNumbrColumIndex));

    // await _inseartString(s, rowId);

    var res = Utils.checkLastFourChars(s);
    if (res.$1) {
      await _inseartString(res.$2, rowId, s, true);
    }
    // bulkInsertVehicleNumbers();
  }

  static List<Map<String, dynamic>> vehicleNumbersToInsert = [];

  static Future<void> _inseartString(
    String word,
    int rowId,
    String og,
    bool isStaff,
  ) async {
    var result = await _database.query(
      trie,
      where: '$charColum = ?',
      whereArgs: [word],
    );
    if (result.isEmpty) {
      await _database.insert(
        trie,
        {
          charColum: word,
          "og": jsonEncode({
            og: [rowId]
          })
        },
      );
    } else {
      Map<String, dynamic> ogs = jsonDecode(result[0]['og'] as String);
      if (ogs.containsKey(og)) {
        ogs[og] = [...ogs[og]!, rowId];
      } else {
        ogs[og] = [rowId];
      }

      await _database.update(
        trie,
        {"og": jsonEncode(ogs)},
        where: '$charColum = ?',
        whereArgs: [word],
      );
    }
  }

  static Future<List<SearchResultItem>> getResult(String number) async {
    List<SearchResultItem> list = [];
    var results = await _database.query(
      trie,
      where: '$charColum = ?',
      whereArgs: [number],
    );
    if (results.isNotEmpty) {
      for (var result in results) {
        Map<String, dynamic> items = jsonDecode(result['og'] as String);
        print(items);
        for (var item in items.entries) {
          List<int> rowIds = item.value.cast<int>();
          list.add(
            SearchResultItem(
              item: item.key,
              rowIds: rowIds,
            ),
          );
        }
      }
    }
    return list;
  }

  static Future<Map<String, String>?> getDetails(int rowId) async {
    var result =
        await _database.query(jsonStore, where: 'id = ?', whereArgs: [rowId]);
    if (result.isNotEmpty) {
      var titles = await _database
          .query(jsonStore, where: 'id = ?', whereArgs: [result[0]['titleId']]);
      if (titles.isNotEmpty) {
        List<String> t =
            (jsonDecode(titles[0]['json_string'] as String) as List)
                .map((e) => e as String)
                .toList();
        List<String> s =
            (jsonDecode(result[0]['json_string'] as String) as List)
                .map((e) => e as String)
                .toList();
        Map<String, String> output = {};
        for (var i = 0; i < t.length; i++) {
          output[t[i]] = s[i];
          if (i == t.length - 1) {
            List<String> fileDetails = t.last.split('______');
            output["file name"] = fileDetails[0];
            output["finance"] = fileDetails[1];
            output["branch"] = fileDetails[2];
          }
        }

        return output;
      }
    }
    return null;
  }

  static Future<List<BankBranch>> getBranches(List<int> rowIds) async {
    List<BankBranch> branches = [];
    for (var element in rowIds) {
      try {
        var rows = await _database
            .query(jsonStore, where: 'id = ?', whereArgs: [element]);
        var list = jsonDecode(rows.last['json_string'] as String);
        var contents = list.last.split('______');
        branches.add(BankBranch(
            bank: contents[1], branch: contents[2], fileName: contents[0]));
      } catch (e) {
        print(e);
        rethrow;
      }
    }
    // return [];
    return branches;
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

Map<String, String> getObject(String rowValues, String titles) {
  List<dynamic> rowMapDynamic = jsonDecode(rowValues);
  List<String> rowMap = rowMapDynamic.map((e) => e.toString()).toList();

  List<dynamic> titleMapDynamic = jsonDecode(titles);
  List<String> titleMap = titleMapDynamic.map((e) => e.toString()).toList();
  Map<String, String> result = {};
  for (var i = 0; i < rowMap.length; i++) {
    var title = titleMap[i];
    String value = rowMap[i];
    result[title] = value;
  }
  if (rowMap.length < titleMap.length) {
    result['File name'] = titleMap.last;
  }

  return result;
}

void redLog(String s) {
  print('\x1B[31mThis is a red message\x1B[0m');
}
