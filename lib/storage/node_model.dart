import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Node {
  final String charecter;
  final int dbId;
  final Map<String, int> children;
  final Map<String, int> og;
  Node({
    required this.charecter,
    required this.dbId,
    required this.children,
    required this.og,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'charecter': charecter,
      'id': dbId,
      'og': og,
      'children': children,
    };
  }

  factory Node.fromMap(Map<String, dynamic> map) {
    return Node(
      charecter: map['charecter'] ?? "",
      dbId: map['id'] as int,
      og: Map<String, dynamic>.from(jsonDecode(map['og']))
          .map((key, value) => MapEntry(key, value as int)),
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
  // final Node node;
  final int rowId;

  SearchResultItem({
    required this.item,
    // required this.node,
    required this.rowId,
  });
}
