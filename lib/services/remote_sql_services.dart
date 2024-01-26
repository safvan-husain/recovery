import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:recovery_app/models/search_item_model.dart';

class RemoteSqlServices {
  static Future<List<SearchResultItem>> searchVehicles(
    String searchTerm,
    String agencyId,
    bool isOnVehicleNumber,
  ) async {
    Dio dio = Dio();
    String url = isOnVehicleNumber
        ? 'https://converter.starkinsolutions.com/search-vn'
        : 'https://converter.starkinsolutions.com/search-cn';
    var response = await dio.post<List>(
      url,
      data: jsonEncode({
        isOnVehicleNumber ? "vehicleNumber" : "chassiNumber": searchTerm,
        "agencyId": agencyId,
      }),
    );
    List<SearchResultItem> result = [];
    // SearchResultItem(item: item, rows: rows)
    // print(response.data);
    if (response.statusCode == 200) {
      List<Map<String, dynamic>> ob = [];
      response.data!.forEach((element) {
        ob.add(element);
      });
      List<Map<String, String>> converted = ob.map((element) {
        return element.map((key, value) {
          // Convert dynamic value to String using toString() method
          return MapEntry(key, value.toString());
        });
      }).toList();
      converted.forEach((element) {
        result.add(SearchResultItem(
            item:
                element[isOnVehicleNumber ? 'VEHICAL NO' : 'CHASSIS NO'] ?? "",
            rows: [element]));
      });
    }
    return SearchResultItem.mergeDuplicateItems(result);
  }
}
