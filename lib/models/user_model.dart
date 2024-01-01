// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  String agent_name;
  String number;
  String email;
  String address;
  String? avatarUrl;
  String? adharUrl;
  String? panUrl;
  String? agencyId;

  UserModel({
    required this.agent_name,
    required this.number,
    required this.email,
    required this.address,
    this.avatarUrl,
    this.adharUrl,
    this.panUrl,
    this.agencyId,
  });

  factory UserModel.fromServerJson(Map<String, dynamic> map) {
    return UserModel(
        agent_name: map['details']['agent_name'] as String,
        number: map['phone'] as String,
        email: '', // Add the correct key if email is present in the JSON
        address: map['details']['address'] as String,
        avatarUrl: map['details']['aadhaar_card'] as String,
        adharUrl: map['details']['aadhaar_card'] as String,
        panUrl: map['details']['pan_card'] as String,
        agencyId: map['details']['agency_id'] as String);
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
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      agent_name: map['agent_name'] as String,
      number: map['number'] as String,
      email: map['email'] as String,
      address: map['address'] as String,
      avatarUrl: map['avatarUrl'] != null ? map['avatarUrl'] as String : null,
      agencyId: map['agency_id'] != null ? map['agency_id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
