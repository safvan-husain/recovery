// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DetailsModel {
  String name;
  String vehicalNo;
  String engineNo;
  String? agreementNumber;
  String? manufecture;
  String? yearManfu;
  String? vehichelModel;
  String? zone;
  String? subZone;
  String? region;
  String? area;
  String? emiStartDate; //
  String? emiLastDate; //
  String? paidTnerGrp; //
  String? cifNumber; //
  String? branch; //
  String? subProduction;
  String? modelManufactior;
  DetailsModel({
    required this.name,
    required this.engineNo,
    required this.vehicalNo,
    this.agreementNumber,
    this.area,
    this.modelManufactior,
    this.branch,
    this.cifNumber,
    this.subProduction,
    this.emiLastDate,
    this.emiStartDate,
    this.manufecture,
    this.paidTnerGrp,
    this.region,
    this.subZone,
    this.vehichelModel,
    this.yearManfu,
    this.zone,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Name': name,
      'Vehical No': vehicalNo,
      'Engine No': engineNo,
      'Agreement Number': agreementNumber,
      'Manufecture': manufecture,
      'Year of Manfu': yearManfu,
      'Vehichel Model': vehichelModel,
      'zone': zone,
      'subZone': subZone,
      'region': region,
      'area': area,
      'emiStartDate': emiStartDate,
      'emiLastDate': emiLastDate,
      'paidTnerGrp': paidTnerGrp,
      'cifNumber': cifNumber,
      'branch': branch,
      'subProduction': subProduction,
      'modelManufactior': modelManufactior,
    };
  }

  factory DetailsModel.fromMap(Map<String, dynamic> map) {
    return DetailsModel(
      name: map['name'] as String,
      vehicalNo: map['vehicalNo'] as String,
      engineNo: map['engineNo'] as String,
      agreementNumber: map['agreementNumber'] != null
          ? map['agreementNumber'] as String
          : null,
      manufecture:
          map['manufecture'] != null ? map['manufecture'] as String : null,
      yearManfu: map['yearManfu'] != null ? map['yearManfu'] as String : null,
      vehichelModel:
          map['vehichelModel'] != null ? map['vehichelModel'] as String : null,
      zone: map['zone'] != null ? map['zone'] as String : null,
      subZone: map['subZone'] != null ? map['subZone'] as String : null,
      region: map['region'] != null ? map['region'] as String : null,
      area: map['area'] != null ? map['area'] as String : null,
      emiStartDate:
          map['emiStartDate'] != null ? map['emiStartDate'] as String : null,
      emiLastDate:
          map['emiLastDate'] != null ? map['emiLastDate'] as String : null,
      paidTnerGrp:
          map['paidTnerGrp'] != null ? map['paidTnerGrp'] as String : null,
      cifNumber: map['cifNumber'] != null ? map['cifNumber'] as String : null,
      branch: map['branch'] != null ? map['branch'] as String : null,
      subProduction:
          map['subProduction'] != null ? map['subProduction'] as String : null,
      modelManufactior: map['modelManufactior'] != null
          ? map['modelManufactior'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DetailsModel.fromJson(String source) =>
      DetailsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
