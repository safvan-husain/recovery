// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:recovery_app/services/utils.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  String agent_name;
  String number;
  String email;
  String address;
  String? avatarUrl;
  String? adharUrl;
  String? panUrl;
  String agencyId;
  bool isStaff;
  String deviceId;

  UserModel({
    required this.agent_name,
    required this.number,
    required this.email,
    required this.address,
    this.avatarUrl,
    this.adharUrl,
    this.panUrl,
    required this.agencyId,
    this.isStaff = true,
    this.deviceId = '',
  });

  Future<bool> verifyDevice() async {
    String imei = await Utils.getImei();
    return imei == deviceId;
  }

  factory UserModel.fromServerJson2(Map<String, dynamic> map) {
    log(map['Add_data']['agency_id']);
    return UserModel(
      agent_name: map['Add_data']['agent_name'] as String,
      number: map['user_data']['phone'] as String,
      email: map['user_data']['email'] as String,
      address: map['Add_data']['address'] as String,
      avatarUrl: map['Add_data']['profile'] as String,
      adharUrl: map['Add_data']['aadhaar_card'] as String,
      panUrl: map['Add_data']['pan_card'] as String,
      agencyId: map['Add_data']['agency_id'].toString(),
      isStaff: int.parse(map['Add_data']['staff']) == 1,
    );
  }

  factory UserModel.fromServerJson(Map<String, dynamic> map) {
    return UserModel(
      agent_name: map['details']['agent_name'] as String,
      number: map['phone'] as String,
      email: map['details']['email']
          as String, // Add the correct key if email is present in the JSON
      address: map['details']['address'] as String,
      avatarUrl: map['details']['aadhaar_card'] as String,
      adharUrl: map['details']['aadhaar_card'] as String,
      panUrl: map['details']['pan_card'] as String,
      agencyId: map['details']['agency_id'] as String,
      isStaff: int.parse(map['details']['staff']) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'agent_name': agent_name,
      'number': number,
      'email': email,
      'address': address,
      'avatarUrl': avatarUrl,
      'adharUrl': adharUrl,
      'panUrl': panUrl,
      'agency_id': agencyId,
      'isStaff': isStaff,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      agent_name: map['agent_name'] as String,
      number: map['number'] as String,
      email: map['email'] as String,
      address: map['address'] as String,
      avatarUrl: map['avatarUrl'] != null ? map['avatarUrl'] as String : null,
      agencyId: map['agency_id'] as String,
      isStaff: map['isStaff'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
