import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // DatabaseHelper._internal();
  static late final Database _database;
  static var jsonStore = 'json_store';
  static var trie = 'trie';

  static Future<void> initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'your_database.db'),
      onCreate: (db, version) async {
        // Create your tables here
        await db.execute(
            'CREATE TABLE $jsonStore (id INTEGER PRIMARY KEY, json_string TEXT)');
        await db.execute('''CREATE TABLE $trie (
  id INTEGER PRIMARY KEY,
  character TEXT,
  rowId TEXT,
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

  static Future<Map<String, Object?>> _getNode(int id) async {
    var node = await _database.query(
      trie,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (node.isEmpty) {
      if (id == 1) {
        await _database.insert(trie, {'character': 'root', 'children': '{}'});
        node = await _database.query(
          trie,
          where: 'character = ?',
          whereArgs: ['root'],
        );
      } else {
        throw ("no node with $id");
      }
    }
    return node[0];
  }

  static Future<void> _updateNode(int id, String children) async {
    await _database.update(
      trie,
      {'children': children},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> _createNode(String char, [int? rowId]) async {
    var id = await _database.insert(
      trie,
      {
        'character': char,
        'children': '{}',
        'rowId': rowId == null ? "[]" : jsonEncode([rowId])
      },
    );
    return id;
  }

  static Future<void> _addRowToNode(int nodeId, int rowId) async {
    var map = await _getNode(nodeId);
    List<dynamic> rowIds = jsonDecode(map['rowId'] as String) ?? [];
    rowIds.add(rowId);
    await _database.update(trie, {"rowId": jsonEncode(rowIds)});
  }

  static Future<int> inseartTitles(List<String> titles) async {
    print("titles added");
    return await _database
        .insert(jsonStore, {'json_string': jsonEncode(titles)});
  }

  static Future<void> inseartRow(List<String> row, int titlesId) async {
    int rowId =
        await _database.insert(jsonStore, {'json_string': jsonEncode(row)});
    for (var element in row) {
      await _inseartString(element, rowId);
    }
  }

  static Future<void> _inseartString(String word, int rowId) async {
    late Map<String, Object?> node;
    int nodeId = 1;
    late Map<String, dynamic> children;
    for (var i = 0; i < word.length; i++) {
      var charecter = word[i];
      node = await _getNode(nodeId);
      children = jsonDecode(node['children'] as String);
      print(children);
      if (children.containsKey(charecter)) {
        nodeId = children[charecter];
        if (word.length == (i + 1)) {
          await _addRowToNode(nodeId, rowId);
        }
      } else {
        var newNodeId =
            await _createNode(charecter, i == word.length - 1 ? rowId : null);
        children[charecter] = newNodeId;
        await _updateNode(nodeId, jsonEncode(children));
        nodeId = newNodeId;
      }
    }
  }

  static Future<List<int>> getDetails(String word) async {
    List<int> rowIds = [];
    int nodeId = 1; // Assuming the root node has id 1
    for (var i = 0; i < word.length; i++) {
      var character = word[i];
      var node = await _getNode(nodeId);
      var children = jsonDecode(node['children'] as String);
      if (!children.containsKey(character)) {
        return [];
      }
      nodeId = children[character];
      print("node id $nodeId");
    }
    // Now we have the node corresponding to the last character of the word
    // Extract the row IDs from the rowId field of the node
    var lastNode = await _getNode(nodeId);
    print(lastNode);
    rowIds = jsonDecode(lastNode['rowId'] as String).cast<int>();
    //TODO:get rowids of the last node in the word string.
    return rowIds;
  }

  static Future<List<String>> showForPrefix(String prefix) async {
    List<String> results = [];
    int nodeId = 1; // Assuming the root node has id 1
    for (var i = 0; i < prefix.length; i++) {
      var character = prefix[i];
      var node = await _getNode(nodeId);
      var children = jsonDecode(node['children'] as String);
      if (!children.containsKey(character)) {
        return [];
      }
      nodeId = children[character];
    }
    // Now we have the node corresponding to the last character of the prefix
    // We need to collect all words that start with this prefix
    await _collectWords(nodeId, prefix, results);
    return results;
  }

  static Future<void> _collectWords(
      int nodeId, String prefix, List<String> results) async {
    var node = await _getNode(nodeId);
    var children = jsonDecode(node['children'] as String);
    if (children.isNotEmpty) {
      // This is an internal node, so we recursively collect words from its children
      for (var childCharacter in children.keys) {
        await _collectWords(
            children[childCharacter], prefix + childCharacter, results);
      }
    } else {
      results.add(prefix);
    }
  }
}
