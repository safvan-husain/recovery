import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/screens/BottomNav/bottom_nav.dart';

class AgencyCodeScreen extends StatefulWidget {
  const AgencyCodeScreen({super.key});

  @override
  State<AgencyCodeScreen> createState() => _AgencyCodeScreenState();
}

class _AgencyCodeScreenState extends State<AgencyCodeScreen> {
  String? agencyName;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome 👋',
                  style: GoogleFonts.outfit(
                    textStyle: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff2c65d8),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                  width: double.infinity,
                ),
                if (agencyName == null)
                  ..._enterPinScreen
                else
                  ..._agencyConfirmScreen,
              ],
            ),
          ),
        ),
        if (_isLoading)
          Stack(
            children: [
              ModalBarrier(
                  dismissible: false, color: Colors.grey.withOpacity(0.3)),
              const Center(child: CircularProgressIndicator()),
            ],
          ),
      ],
    );
  }

  List<Widget> get _enterPinScreen {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          'Enter 4 digit pin denoting your agency to complete the sign up process',
          style: GoogleFonts.outfit(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xff23202a),
            ),
          ),
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(height: 20),
      OtpTextField(
        numberOfFields: 4,
        borderColor: Color(0xFF512DA8),
        enabledBorderColor: Color.fromARGB(255, 182, 152, 251),
        //set to true to show as box or false to show as dash
        showFieldAsBox: true,
        //runs when a code is typed in
        onCodeChanged: (String code) {
          //handle validation or checks here
        },
        //runs when every textfield is filled
        onSubmit: getAgencyName, // end onSubmit
      )
    ];
  }

  List<Widget> get _agencyConfirmScreen {
    return [
      Text(
        'Is it the agency you are looking for?',
        style: GoogleFonts.outfit(
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xff23202a),
          ),
        ),
      ),
      const SizedBox(height: 20),
      Container(
        margin: const EdgeInsets.all(5),

        // width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          // border: Border.all(color: Colors.grey, width: 1.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                agencyName!,
                style: GoogleFonts.oswald(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      agencyName = null;
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey, width: 1.0),
                    ),
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BottomNavView()),
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey, width: 1.0),
                    ),
                    child: Text(
                      "Confirm",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      )
    ];
  }

  void getAgencyName(String verification) async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(seconds: 3), () {
      setState(() {
        agencyName = "Starkin Solution pvt lmtd";
      });
      setState(() {
        _isLoading = false;
      });
    });
  }
}
