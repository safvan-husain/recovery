import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class DeviceVerifyScreen extends StatefulWidget {
  const DeviceVerifyScreen({super.key});

  @override
  State<DeviceVerifyScreen> createState() => _DeviceVerifyScreenState();
}

class _DeviceVerifyScreenState extends State<DeviceVerifyScreen> {
  bool _isRequested = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 244, 255),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _isRequested
                    ? "The agency will let you know once your request has been approved."
                    : "We hve detected that your device Id has changed, if you activate this Id the older one will be removed",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              if (!_isRequested)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isRequested = true;
                    });
                  },
                  child: Text(
                    "Request to activate this device",
                    style:
                        GoogleFonts.poppins(fontSize: 18, color: Colors.white),
                  ),
                ),
              ElevatedButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text(
                  "Exit the app",
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
