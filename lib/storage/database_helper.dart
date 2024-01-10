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
  rowId TEXT,
  og TEXT,
  children TEXT, 
  FOREIGN KEY(rowId) REFERENCES $jsonStore(id)
)''');
      },
      version: 1,
    );
  }

  static Future<void> deleteAllData() async {
    await _database.delete(jsonStore);
    await _database.delete(trie);
  }

  static Future<Node> _getNode(int id) async {
    var node = await _database.query(
      trie,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (node.isEmpty) {
      if (id == 1) {
        await _database.insert(trie,
            {charColum: 'root', 'children': '{}', 'rowId': '[]', 'og': '[]'});
        node = await _database.query(
          trie,
          where: '$charColum = ?',
          whereArgs: ['root'],
        );
      } else {
        throw ("no node with $id");
      }
    }
    return Node.fromMap(node[0]);
  }

  static Future<void> _updateNode(int id, String children) async {
    await _database.update(
      trie,
      {'children': children},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> _createNode(String char, [int? rowId, String? og]) async {
    var id = await _database.insert(
      trie,
      {
        charColum: char,
        'children': '{}',
        'rowId': rowId == null ? "[]" : jsonEncode([rowId]),
        'og': rowId == null ? "[]" : jsonEncode([og])
      },
    );
    return id;
  }

  static Future<int> inseartTitles(List<String> titles) async {
    return await _database
        .insert(jsonStore, {'json_string': jsonEncode(titles)});
  }

  static Future<void> inseartRow(
      List<String> row, int titlesId, int vehicalNumbrColumIndex) async {
    int rowId = await _database.insert(
        jsonStore, {'json_string': jsonEncode(row), 'titleId': titlesId});
    var s = Utils.removeHyphens(row.elementAt(vehicalNumbrColumIndex));

    await _inseartString(s, rowId);

    var res = Utils.checkLastFourChars(s);
    if (res.$1) {
      await _inseartString(res.$2, rowId, s);
    }
  }

  static Future<void> _inseartString(
    String word,
    int rowId, [
    String? og,
  ]) async {
    Node? node;
    int nodeId = 1;
    late Map<String, dynamic> children;
    for (var i = 0; i < word.length; i++) {
      var charecter = word[i];
      node = await _getNode(nodeId);
      children = node.children;
      if (children.containsKey(charecter)) {
        nodeId = children[charecter];
        children = {};
      } else {
        var newNodeId =
            await _createNode(charecter, i == word.length - 1 ? rowId : null);
        children[charecter] = newNodeId;
        await _updateNode(nodeId, jsonEncode(children));
        nodeId = newNodeId;
      }
      if (i == word.length - 1) {
        node = await _getNode(nodeId);
        List<String> ogs = [];
        if (og != null) {
          ogs = node.og;
        }
        List<int> rowIds = node.rowId;
        if (!rowIds.contains(rowId)) {
          rowIds.add(rowId);
          if (og != null && !ogs.contains(og)) {
            ogs.add(og);
            await _database.update(
                trie, {"rowId": jsonEncode(rowIds), 'og': jsonEncode(ogs)},
                where: 'id = ?', whereArgs: [node.dbId]);
          } else {
            await _database.update(trie, {"rowId": jsonEncode(rowIds)},
                where: 'id = ?', whereArgs: [node.dbId]);
          }
        }
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
        for (var i = 0; i < t.length; i++) {
          output[t[i]] = s[i];
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
    for (var i = 0; i < prefix.length; i++) {
      var character = prefix[i];
      var node = await _getNode(nodeId);
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
    print(results.length);
    return results;
  }

  static Future<void> _collectWords(
      int nodeId, String prefix, List<SearchResultItem> results) async {
    var node = await _getNode(nodeId);
    var children = node.children;
    if (children.isNotEmpty) {
      if (node.rowId.isNotEmpty) {
        results.add(SearchResultItem(item: prefix, node: node));
      }
      // This is an internal node, so we recursively collect words from its children
      for (var childCharacter in children.keys) {
        await _collectWords(
            children[childCharacter]!, prefix + childCharacter, results);
      }
    } else {
      if (node.og.isNotEmpty) {
        for (var element in node.og) {
          results.add(SearchResultItem(item: element, node: node));
        }
      } else {
        results.add(SearchResultItem(item: prefix, node: node));
      }
    }
  }
}

void redLog(String s) {
  print('\x1B[31mThis is a red message\x1B[0m');
}
