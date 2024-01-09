import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Node {
  final String charecter;
  final int dbId;
  final List<int> rowId;
  final Map<String, int> children;
  Node({
    required this.charecter,
    required this.dbId,
    required this.rowId,
    required this.children,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'charecter': charecter,
      'id': dbId,
      'rowId': rowId,
      'children': children,
    };
  }

  factory Node.fromMap(Map<String, dynamic> map) {
    return Node(
      charecter: map['charecter'] ?? "",
      dbId: map['id'] as int,
      rowId: (jsonDecode(map['rowId']) as List).map((e) => e as int).toList(),
      children: Map<String, dynamic>.from(jsonDecode(map['children']))
          .map((key, value) => MapEntry(key, value as int)),
    );
  }

  String toJson() => json.encode(toMap());

  factory Node.fromJson(String source) =>
      Node.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SearchResultItem {
  final String item;
  final Node node;

  SearchResultItem({
    required this.item,
    required this.node,
  });
}
