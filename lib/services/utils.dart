import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_imei/device_imei.dart';
import 'package:flutter/services.dart';

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
    //last four digit in vehicle registration number.
    String lastFour = str.substring(str.length - 4);
    bool isAllNumbers = RegExp(r'^\d+$').hasMatch(lastFour);
    return (isAllNumbers, lastFour);
  }

  static Future<bool> sendSMS(String message) async {
    final Uri url = Uri(
      scheme: 'sms',
      // path: '+917907320942',
      queryParameters: {
        'body': "$message \n",
      },
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
      return true;
    }
    return false;
  }

  static Future<bool> sendWhatsapp(
    String agencyName,
    Map<String, String> details,
    String status,
    // String message,
    String agentName,
    String phone,
    String address, [
    String? location,
    String? load,
  ]) async {
    // ) async {
    var text =
        'Respected Sir, \n\n${formatMap(details)}\n \n${location != null ? "location : $location" : ""}\nReporting address : $address \ncarries Goods : $load  \nStatus : $status  \n$agentName : +91 $phone \n\nAgency: $agencyName';
    String url = 'whatsapp://send?&text=$text';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
      return true;
    }
    return false;
  }

  static String formatMap(Map<String, String> map) {
    List<String> shareableKey = [
      "customer name",
      "vehical no",
      "chassis no",
      "model",
      "make",
      "engine no",
      // "agreement no",
    ];
    return map.entries
        .where((element) => shareableKey.contains(element.key.toLowerCase()))
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

  static void saveIdCard(
    GlobalKey<State<StatefulWidget>> globalKey,
    BuildContext context,
  ) async {
    PermissionStatus status = await Permission.storage.status;

    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    if (!status.isGranted) {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final result =
          await ImageGallerySaver.saveImage(byteData!.buffer.asUint8List());
      if (context.mounted) toastBar("Id card saved").show(context);
    } else {
      if (context.mounted) {
        toastBar("Permission denied to save Id card").show(context);
      }
    }
  }

  static String formatString(String input) {
    // Replace "_" and "-" with spaces
    String formatted = input.replaceAll('_', ' ').replaceAll('-', ' ');

    // Capitalize the first letter of each word
    List<String> words = formatted.split(' ');
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        words[i] = words[i][0].toUpperCase() + words[i].substring(1);
      }
    }

    return words.join(' ');
  }

  static Future<String> getImei() async {
    const platform = MethodChannel('androidId');
    return await platform.invokeMethod('getId');
  }
}
