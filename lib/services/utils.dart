import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  static String removeHyphens(String input) {
    return input.replaceAll('-', '').replaceAll(' ', '').toLowerCase();
  }

  static Future<bool> launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
      return true;
    }
    return false;
  }

  static (bool isNumber, String number) checkLastFourChars(String str) {
    if (str.length < 5) {
      return (false, '');
    }
    String lastFour = str.substring(str.length - 4);
    bool isAllNumbers = RegExp(r'^\d+$').hasMatch(lastFour);
    return (isAllNumbers, lastFour);
  }

  static Future<bool> sendSMS(String message, String status) async {
    final Uri url = Uri(
      scheme: 'sms',
      // path: '+917907320942',
      queryParameters: {
        'body': "$message \n status: $status",
      },
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
      return true;
    }
    return false;
  }

  static Future<bool> sendWhatsapp(
    Map<String, String> details,
    String status,
    // String message,
    String agencyName,
    String phone,
    String address, [
    String? location,
    String? load,
  ]) async {
    var text =
        '${formatMap(details)} ${location != null ? "location : $location" : ""}\n Reporting address : $address \n carries Goods : $load   \n  \n Status : $status \n  \n $agencyName : +91 $phone';
    String url = 'whatsapp://send?&text=$text';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
      return true;
    }
    return false;
  }

  static String formatMap(Map<String, String> map) {
    List<String> shareableKey = [
      "vehical no",
      "chassis no",
      "model/make",
      "engine no",
      "agreement no",
      "customer name"
    ];
    return map.entries
        .where((element) => shareableKey.contains(element.key))
        .map((entry) => '${entry.key} : ${entry.value}')
        .join('\n');
  }

  static double calculatePercentage(int current, int total) {
    return ((current / total) * 100).toDouble();
  }

  static DelightToastBar toastBar(String message, [Color? color]) {
    return DelightToastBar(
      autoDismiss: true,
      snackbarDuration: const Duration(seconds: 3),
      builder: (context) => ToastCard(
        color: color ?? Colors.red,
        leading: const Icon(
          Icons.flutter_dash,
          size: 28,
          color: Colors.red,
        ),
        title: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
