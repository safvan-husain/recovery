import 'dart:convert';
import 'dart:developer';

import 'package:recovery_app/services/csv_file_service.dart';
import 'package:recovery_app/services/utils.dart';
import 'package:recovery_app/storage/node_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
  og TEXT,
  children TEXT
)''');
      },
      version: 1,
    );
  }

  static Future<void> deleteAllData() async {
    await _database.delete(jsonStore);
    await _database.delete(trie);
  }

  static Future<Node> _getNode(
    int id,
    Transaction? txn,
  ) async {
    if (txn == null) {
      var nodeList = await _database.query(
        trie,
        where: 'id = ?',
        whereArgs: [id],
      );
      if (nodeList.isEmpty) {
        if (id == 1) {
          await _database
              .insert(trie, {charColum: 'root', 'children': '{}', 'og': '{}'});
          nodeList = await _database.query(
            trie,
            where: '$charColum = ?',
            whereArgs: ['root'],
          );
        } else {
          throw ("no node with $id");
        }
      }
      return Node.fromMap(nodeList[0]);
    }
    var nodeList = await txn.query(
      trie,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (nodeList.isEmpty) {
      if (id == 1) {
        await txn
            .insert(trie, {charColum: 'root', 'children': '{}', 'og': '{}'});
        nodeList = await txn.query(
          trie,
          where: '$charColum = ?',
          whereArgs: ['root'],
        );
      } else {
        throw ("no node with $id");
      }
    }
    return Node.fromMap(nodeList[0]);
  }

  static Future<void> _updateNode(
    int id,
    String children,
    Transaction txn,
  ) async {
    await txn.update(
      trie,
      {'children': children},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> _createNode(
    String char,
    Transaction txn, [
    int? rowId,
    String? og,
  ]) async {
    return await txn.insert(
      trie,
      {
        charColum: char,
        'children': '{}',
        'og': og == null
            ? "{}"
            : jsonEncode({
                og: [rowId]
              })
      },
    );
  }

  static Future<int> inseartTitles(List<String> titles) async {
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
      // Instead of inserting immediately, accumulate the data
      // vehicleNumbersToInsert.add({charColum: res.$2, 'rowId': rowId, 'og': s});
      await _database.transaction((txn) async {
        var batch = txn.batch();
        await _inseartString(txn, res.$2, rowId, s, true);
        await batch.commit();
      });
      log("transaction completed");
    }
    // bulkInsertVehicleNumbers();
  }

  static List<Map<String, dynamic>> vehicleNumbersToInsert = [];

  // static Future<void> bulkInsertVehicleNumbers() async {
  //   // Begin a transaction
  //   await _database.transaction((txn) async {
  //     for (var vehicleNumberData in vehicleNumbersToInsert) {
  //       await _inseartString(
  //         txn,
  //         vehicleNumberData[charColum],
  //         vehicleNumberData['rowId'],
  //         vehicleNumberData['og'],
  //         true,
  //       );
  //     }
  //   });
  //   // Clear the list after successful insertion
  //   vehicleNumbersToInsert.clear();
  // }

  static Future<void> _inseartString(
    Transaction txn,
    String word,
    int rowId,
    String og,
    bool isStaff,
  ) async {
    Node? node;
    int nodeId = 1;
    Map<String, dynamic> children = {};

    for (var i = 0; i < word.length; i++) {
      var charecter = word[i];
      bool isLastChar = i == word.length - 1;
      node = await _getNode(nodeId, txn);
      // print(node.charecter);
      // print(node.children);
      children = node.children;
      if (children.containsKey(charecter)) {
        nodeId = children[charecter];
        if (isLastChar) {
          node = await _getNode(nodeId, txn);
          Map<String, List<int>> ogs = {};
          ogs = node.og;
          if (!ogs.entries.map((e) => e.key).contains(og)) {
            ogs[og] = [rowId];
            await txn.update(trie, {'og': jsonEncode(ogs)},
                where: 'id = ?', whereArgs: [node.dbId]);
          } else {
            if (isStaff) {
              List<int> rowIds = {...ogs[og]!, rowId}.toList();
              ogs[og] = rowIds;
              await txn.update(trie, {'og': jsonEncode(ogs)},
                  where: 'id = ?', whereArgs: [node.dbId]);
            }
          }
        }
      } else {
        late int newNodeId;
        if (isLastChar) {
          // saving time of execution, doesn't need new id becuse this is the last in the word.
          newNodeId = await _createNode(charecter, txn, rowId, og);
        } else {
          newNodeId = await _createNode(charecter, txn);
        }
        children[charecter] = newNodeId;
        await _updateNode(nodeId, jsonEncode(children), txn);
        nodeId = newNodeId;
      }
    }
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
        for (var i = 0; i < s.length; i++) {
          output[t[i]] = s[i];
        }
        if (t.length > s.length) {
          output["File name"] = t.last;
        }
        return output;
      }
    }
    return null;
  }

  static Future<List<SearchResultItem>> showForPrefix(String prefix) async {
    log(prefix);
    List<SearchResultItem> results = [];
    int nodeId = 1; // Assuming the root node has id 1
    // await _database.transaction((txn) async {
    //   var batch = txn.batch();
    //   await _inseartString(txn, res.$2, rowId, s, true);
    //   await batch.commit();
    // });
    for (var i = 0; i < prefix.length; i++) {
      var character = prefix[i];
      var node = await _getNode(nodeId, null);
      print(node.charecter);
      print(node.children);
      var children = node.children;
      if (!children.containsKey(character)) {
        return [];
      }
      nodeId = children[character]!;
    }

    // Now we have the node corresponding to the last character of the prefix
    // We need to collect all words that start with this prefix
    await _collectWords(nodeId, prefix, results);
    // print(results.length);
    return results;
  }

  static Future<void> _collectWords(
      int nodeId, String prefix, List<SearchResultItem> results) async {
    var node = await _getNode(nodeId, null);
    var children = node.children;
    if (children.isNotEmpty) {
      for (var childCharacter in children.keys) {
        await _collectWords(
            children[childCharacter]!, prefix + childCharacter, results);
      }
    } else {
      if (node.og.isNotEmpty) {
        for (var element in node.og.entries) {
          results
              .add(SearchResultItem(item: element.key, rowIds: element.value));
        }
      }
    }
  }

  static Future<List<String>> getBranches(List<int> rowIds) async {
    print(rowIds);
    List<String> branches = [];
    for (var element in rowIds) {
      try {
        var rows = await _database
            .query(jsonStore, where: 'id = ?', whereArgs: [element]);
        var tites = await _database
            .query(jsonStore, where: 'id = ?', whereArgs: [rows[0]['titleId']]);
        var mapDetails = getObject(rows[0]['json_string'] as String,
            tites[0]['json_string'] as String);
        if (mapDetails.containsKey('BRANCH')) {
          branches.add(mapDetails['BRANCH']!);
        }
      } catch (e) {
        print(e);
        rethrow;
      }
    }
    // return [];
    return branches.toSet().toList();
  }
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
