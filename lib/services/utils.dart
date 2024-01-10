import 'package:connectivity_plus/connectivity_plus.dart';
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

  static Future<bool> sendSMS(String message) async {
    final Uri url = Uri(
      scheme: 'sms',
      path: '+917907320942',
      queryParameters: {
        'body': message,
      },
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
      return true;
    }
    return false;
  }
}
