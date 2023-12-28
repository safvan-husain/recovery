import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/resources/text_fiealds.dart';
import 'package:recovery_app/screens/BottomNav/bottom_nav.dart';
import 'package:recovery_app/screens/authentication/login.dart';
import 'package:recovery_app/screens/authentication/sign_up_screen.dart';
import 'package:recovery_app/services/auth_services.dart';

class OtpLogin extends StatefulWidget {
  const OtpLogin({super.key});

  @override
  State<OtpLogin> createState() => _OtpLoginState();
}

class _OtpLoginState extends State<OtpLogin> {
  final TextEditingController _emailController = TextEditingController();
  String? otp;
  @override
  Widget build(BuildContext context) {
    var isOtpGenerated = otp != null;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 100),
              child: Column(
                mainAxisAlignment: isOtpGenerated
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(isOtpGenerated
                      ? 'assets/images/otp.png'
                      : 'assets/images/phone-verify.png'),
                  if (!isOtpGenerated) ...[
                    Text(
                      'Verify your phone number',
                      style: GoogleFonts.outfit(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff23202a),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        buildPhoneInputFieald(
                          controller: _emailController,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: true,
                              onChanged: (value) {},
                            ),
                            const Text('Remember'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        // if (_emailController.text.isEmpty ||
                        //     _passwordController.text.isEmpty ||
                        //     _userNameController.text.isEmpty ||
                        //     _passwordController.text.isEmpty) {
                        //   showSnackbar("Every fieald required", context);
                        //   return;
                        // }
                        otp = await AuthServices.verifyPhone(
                          phone: _emailController.text,
                          context: context,
                        );
                      },
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all<TextStyle>(
                          const TextStyle(color: Colors.white),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 100), // Adjust the padding here
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xff2c65d8)),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      child: Text(
                        'Get OTP',
                        maxLines: 1,
                        style: GoogleFonts.outfit(
                          textStyle: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "OR",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 16,
                          // fontWeight: FontWeight.bold, // Makes the text bold
                          letterSpacing:
                              1.2, // Increases spacing between letters
                        ),
                      ),
                    ),
                    InkWell(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          "Login With Password",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w400, // Makes the text bold
                            letterSpacing:
                                1.2, // Increases spacing between letters
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (c) => const Login()),
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (c) => SignUpScreen()));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?"),
                          SizedBox(width: 5),
                          Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Color(0xff2c65d8),
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    )
                  ] else
                    ..._enterPinScreen,
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> get _enterPinScreen {
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "OTP verification",
          style: GoogleFonts.poppins(
            color: Colors.blue,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          'Enter the otp send to +91000000000',
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
        onSubmit: (v) {
          if (v == otp) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavView()),
            );
          }
        }, // end onSubmit
      ),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Did not recieve the OTP?',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'Resend OTP?',
              style: TextStyle(
                color: Color(0xff2c65d8),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: () {
          // if (_emailController.text.isEmpty ||
          //     _passwordController.text.isEmpty ||
          //     _userNameController.text.isEmpty ||
          //     _passwordController.text.isEmpty) {
          //   showSnackbar("Every fieald required", context);
          //   return;
          // }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavView()),
          );
        },
        style: ButtonStyle(
          textStyle: MaterialStateProperty.all<TextStyle>(
            const TextStyle(color: Colors.white),
          ),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(
                vertical: 16, horizontal: 100), // Adjust the padding here
          ),
          backgroundColor:
              MaterialStateProperty.all<Color>(const Color(0xff2c65d8)),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        child: Text(
          'Verify Phone',
          maxLines: 1,
          style: GoogleFonts.outfit(
            textStyle: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ];
  }
}
