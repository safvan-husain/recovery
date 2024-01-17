import 'dart:convert';

import 'package:dio/dio.dart';

class ControlPanelService {
  static final Dio dio = Dio();

  static Future<List<Agent>> getAllUsers(String agencyId) async {
    var response = await dio.get(
      "https://www.recovery.starkinsolutions.com/alluser.php",
    );
    if (response.statusCode == 200) {
      List<dynamic> data = response.data;
      List<Agent> agents = data
          .where((element) => element['agency_id'] == agencyId)
          .map((item) => Agent.fromJson(item))
          .toList();
      return agents;
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<List<String>> getAllFinances(String agencyId) async {
    List<String> banksList = [];
    var response = await dio.get(
      "https://www.recovery.starkinsolutions.com/Allbankbranch.php",
      data: jsonEncode({"admin_id": agencyId}),
    );
    if (response.statusCode == 200) {
      var banks = response.data['banks'];
      for (var element in banks) {
        banksList.add(element['bank']);
      }
    } else {
      throw Exception('Failed to load users');
    }
    return banksList;
  }

  static void switchAdminAccess(bool value, int agentId) async {
    var response = await dio.post(
      "https://www.recovery.starkinsolutions.com/addremove.php",
      data: jsonEncode({"id": "$agentId", "staff": value ? "1" : "0"}),
    );
    print(response.data);
  }
}

class Agent {
  final int id;
  final String profile;
  final String agentName;
  final String email;
  final String address;
  final String aadhaarCard;
  final String panCard;
  final int adminId;
  final int agencyId;
  final bool staff;
  final int status;
  final DateTime dateAdded;
  final DateTime dateModified;

  Agent({
    required this.id,
    required this.profile,
    required this.agentName,
    required this.email,
    required this.address,
    required this.aadhaarCard,
    required this.panCard,
    required this.adminId,
    required this.agencyId,
    required this.staff,
    required this.status,
    required this.dateAdded,
    required this.dateModified,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: int.parse(json['id']),
      profile: json['profile'],
      agentName: json['agent_name'],
      email: json['email'],
      address: json['address'],
      aadhaarCard: json['aadhaar_card'],
      panCard: json['pan_card'],
      adminId: int.parse(json['admin_id']),
      agencyId: int.parse(json['agency_id']),
      staff: int.parse(json['staff']) == 1,
      status: int.parse(json['status']),
      dateAdded: DateTime.parse(json['date_added']),
      dateModified: DateTime.parse(json['date_modified']),
    );
  }
}
