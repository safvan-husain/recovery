import 'dart:convert';

class AgencyDetails {
  // String id;
  String agencyName;
  String address;
  String contact;
  // String aadhaarCard;
  // String panCard;
  // String shopAct;
  // String gst;
  // DateTime startDate;
  // DateTime endDate;
  // int remainingDays;
  // String adminId;
  // String validityPlansId;
  // String agentsNo;
  // String status;
  // DateTime dateAdded;
  // DateTime dateModified;

  AgencyDetails({
    // required this.id,
    required this.agencyName,
    required this.address,
    required this.contact,
    // required this.aadhaarCard,
    // required this.panCard,
    // required this.shopAct,
    // required this.gst,
    // required this.startDate,
    // required this.endDate,
    // required this.adminId,
    // required this.validityPlansId,
    // required this.agentsNo,
    // required this.status,
    // required this.dateAdded,
    // required this.dateModified,
    // }) : remainingDays = _calculateRemainingDays(endDate);
    // static int _calculateRemainingDays(DateTime end) {
    //   int daysRemaining = end.difference(DateTime.now()).inDays;
    //   return daysRemaining < 0 ? 0 : daysRemaining;
    // }
  });
  factory AgencyDetails.fromRawJson(String str) =>
      AgencyDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AgencyDetails.fromJson(Map<String, dynamic> json) => AgencyDetails(
        // id: json["id"],
        agencyName: json["agency_name"],
        address: json["address"],
        contact: json["contact"],
        // aadhaarCard: json["aadhaar_card"],
        // panCard: json["pan_card"],
        // shopAct: json["shop_act"],
        // gst: json["gst"],
        // startDate: DateTime.parse(json["start_date"]),
        // endDate: DateTime.parse(json["end_date"]),
        // adminId: json["admin_id"],
        // validityPlansId: json["validity_plans_id"],
        // agentsNo: json["agents_no"],
        // status: json["status"],
        // dateAdded: DateTime.parse(json["date_added"]),
        // dateModified: DateTime.parse(
        //   json["date_modified"],
        // ),
      );

  Map<String, dynamic> toJson() => {
        // "id": id,
        "agency_name": agencyName,
        "address": address,
        "contact": contact,
        // "aadhaar_card": aadhaarCard,
        // "pan_card": panCard,
        // "shop_act": shopAct,
        // "gst": gst,
        // "start_date": startDate.toIso8601String(),
        // "end_date": endDate.toIso8601String(),
        // "admin_id": adminId,
        // "validity_plans_id": validityPlansId,
        // "agents_no": agentsNo,
        // "status": status,
        // "date_added": dateAdded.toIso8601String(),
        // "date_modified": dateModified.toIso8601String(),
      };
  Map<String, dynamic> toDisplayMap() => {
        // "id": id,
        "name": agencyName,
        "address": address,
        "contact": contact,
        // "aadhaar_card": aadhaarCard,
        // "pan_card": panCard,
        // "shop_act": shopAct,
        // "gst": gst,
        // "start_date": startDate.toIso8601String(),
        // "end_date": endDate.toIso8601String(),
        // "admin_id": adminId,
        // "validity_plans_id": validityPlansId,
        // "agents_no": agentsNo,
        // "status": status,
        // "date_added": dateAdded.toIso8601String(),
        // "date_modified": dateModified.toIso8601String(),
      };
}
