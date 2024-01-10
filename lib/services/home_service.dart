import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:recovery_app/models/detail_model.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:recovery_app/storage/user_storage.dart';

class HomeServices {
  List<String> getCarouselItems() => [
        "https://images.unsplash.com/photo-1682686581221-c126206d12f0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxfHx8ZW58MHx8fHx8&auto=format&fit=crop&w=500&q=60",
        "https://images.unsplash.com/photo-1682686581663-179efad3cd2f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxNnx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
        "https://images.unsplash.com/photo-1682695797873-aa4cb6edd613?ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwyMXx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60"
      ];
  static Future<int> getSubsction() async {
    int? remaingDays = await Storage.getRemaingDays();
    if (remaingDays != null && remaingDays > 0) {
      return remaingDays;
    } else {
      try {
        final connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
        } else {
          Dio dio = Dio();

          var response = await dio.post(
            "https://www.recovery.starkinsolutions.com/subscription.php",
            data: jsonEncode({"id": "1"}),
          );

          if (response.statusCode == 200) {
            var data = response.data[0];
            await Storage.storeEndData(data['end_date']);
            DateTime endDate = DateTime.parse(data['end_date']);
            int daysRemaining = endDate.difference(DateTime.now()).inDays;
            return daysRemaining < 1 ? 0 : daysRemaining;
          }
        }
      } catch (e) {
        print(e);
      }
    }

    return 0;
  }
}
