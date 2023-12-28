import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

Future<List<double>> _getCurrentLocation() async {
  List<double> list = [];
  final permission = await Permission.location.request();

  if (permission.isGranted) {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    list.add(position.latitude);
    list.add(position.longitude);
    print(
        'https://maps.google.com/?q=${position.latitude},${position.longitude}');
    print('Location: ${position.latitude}, ${position.longitude}');
  } else {
    print('Location permissions have not been granted.');
  }
  return list;
}

class LocationService {
  static Future<void> share() async {
    _getCurrentLocation();
  }
}
