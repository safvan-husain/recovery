import 'dart:io';
import 'package:flutter_launcher_icons/config/config.dart';
import 'package:flutter_launcher_icons/logger.dart';
import 'package:xml/xml.dart';
import 'package:flutter_launcher_icons/main.dart';
import 'package:path/path.dart' as path;

void main() async {
  File('build_log.txt').writeAsStringSync('');
  File('move_log.txt').writeAsStringSync('');
  var iconDir = Directory('iconlist');
  var iconFiles = iconDir
      .listSync()
      .where(
        (item) =>
            item is File &&
            (item.path.endsWith('.jpeg') ||
                item.path.endsWith('.png') ||
                item.path.endsWith('.jpg')),
      )
      .toList();
  var iconFile = iconFiles[0];
  // for (var iconFile in iconFiles) {
  var appName = path.basenameWithoutExtension(iconFile.path);
  var config = Config(
    imagePath: iconFile.path,
    android: true,
    ios: true,
  );
  var logger = FLILogger(true);
  try {
    await createIconsFromConfig(config, logger, iconFile.path);
  } catch (e) {
    print(e);
  }
  // Change Android app name
  final androidManifestFile = File('android/app/src/main/AndroidManifest.xml');
  final androidManifest =
      XmlDocument.parse(androidManifestFile.readAsStringSync());
  final applicationNode = androidManifest.findAllElements('application').first;
  applicationNode.attributes
      .firstWhere((attr) => attr.name.local == 'label')
      .value = appName;
  androidManifestFile.writeAsStringSync(
      androidManifest.toXmlString(pretty: true, indent: '\t'));

  // Change iOS app name
  final infoPlistFile = File('ios/Runner/Info.plist');
  final infoPlist = XmlDocument.parse(infoPlistFile.readAsStringSync());
  final dictNode = infoPlist.findAllElements('dict').first;
  final appNameKeyNode = dictNode.children.firstWhere((node) {
    // print(node.text.contains('CFBundleName'));
    return node.text.contains('CFBundleName');
  });

  appNameKeyNode.nextSibling!.nextSibling!.innerText = appName;
  infoPlistFile
      .writeAsStringSync(infoPlist.toXmlString(pretty: true, indent: '\t'));
  print('Running batch file...');
  var result = Process.runSync('build_apk.bat', [
    "C:\\Users\\safva\\OneDrive\\Desktop\\Recovery",
    appName,
    "C:\\Users\\safva\\OneDrive\\Desktop\\Recovery\\generated-apk"
  ]);
  print("build command complete");
  Process.runSync('move_apk.bat', [appName]);
  print('Batch file execution completed.');
  print(result.stdout);
  print(result.stderr);
  // }
}
