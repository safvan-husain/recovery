import 'package:flutter/services.dart';
import 'package:sim_card_info/sim_card_info.dart';
import 'package:sim_card_info/sim_info.dart';

class SimServices {
  static Future<List<String>> _getPhoneNumbers() async {
    final simCardInfoPlugin = SimCardInfo();
    List<String> phoneNumbers = [];
    List<SimInfo>? simCardInfo;

    try {
      simCardInfo = await simCardInfoPlugin.getSimInfo() ?? [];
      for (var element in simCardInfo) {
        phoneNumbers.add(element.number.substring(3));
      }
    } on PlatformException {
      simCardInfo = [];
    }
    return phoneNumbers;
  }

  static Future<bool> verifyPhoneNumber(String number) async {
    return true;
    List<String> phoneNumbers = await _getPhoneNumbers();
    return phoneNumbers.contains(number);
  }
}
