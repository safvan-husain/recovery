// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:recovery_app/services/utils.dart';
import 'package:recovery_app/models/search_item_model.dart';

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
        await db.execute('''CREATE TABLE $trie (
  id INTEGER PRIMARY KEY,
  $charColum TEXT,
  og TEXT,
  details TEXT
)''');
      },
      version: 1,
    );
  }

  static Future<void> deleteAllData() async {
    await _database.delete(trie);
  }

  static Future<void> bulkInsertVehicleNumbers(
    List<List<String>> rows,
    List<String> titles,
    int vehicleNumberColumIndex,
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
    int vehicalNumbrColumIndex,
    Batch batch,
  ) async {
    var s = Utils.removeHyphens(row.elementAt(vehicalNumbrColumIndex));

    var res = Utils.checkLastFourChars(s);
    if (res.$1) {
      await _insertString(res.$2, row, titles, s, true, batch);
    }
  }

  static Future<void> _insertString(
    String word,
    List<String> row,
    List<String> titles,
    String og,
    bool isStaff,
    Batch batch,
  ) async {
    var details = {};
    for (var i = 0; i < titles.length; i++) {
      details[titles[i]] = row[i];
    }
    List<String> content = row.last.split("______");
    details["file name"] = content[0];
    details["finance"] = content[1];
    details["branch"] = content[2];
    batch.insert(
      trie,
      {
        charColum: word,
        "og": og,
        'details': jsonEncode(details),
      },
    );
  }

  static Future<List<SearchResultItem>> getResult(String number) async {
    List<SearchResultItem> list = [];
    var results = await _database.query(
      trie,
      where: '$charColum = ?',
      whereArgs: [number],
    );
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
            item: element['og'] as String,
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
