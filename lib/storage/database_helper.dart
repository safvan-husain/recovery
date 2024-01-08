import 'dart:async';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  late final Database _database;
  var jsonStore = 'json_store';
  var trie = 'trie';

  Future<void> initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'your_database.db'),
      onCreate: (db, version) async {
        // Create your tables here
        await db.execute(
            'CREATE TABLE $jsonStore (id INTEGER PRIMARY KEY, json_string TEXT)');
        await db.execute('''CREATE TABLE $trie (
   id INTEGER PRIMARY KEY,
   parent_id INTEGER,
   value CHAR(1),
   ${jsonStore}_id INTEGER, -- ID of $jsonStore determining the end of a word
   children TEXT, -- Map<char, ${jsonStore}_id of another $trie node>
   FOREIGN KEY(parent_id) REFERENCES $trie(id),
   FOREIGN KEY(${jsonStore}_id) REFERENCES $jsonStore(id)
)''');
      },
      version: 1,
    );
  }

  Future<void> insertRow(Map<String, String> row) async {
    var id = await _database.insert(jsonStore, {"json_string": row.toString()});
    var elements = row.entries.map((e) => e.value).toList();
    for (var element in elements) {
      for (var i = 0; i < element.length; i++) {
        var char = element[i];
      }
    }
  }

  Future<void> searchItems(String query) async {}

  Future<void> getItemDetails(int itemId) async {}
}
