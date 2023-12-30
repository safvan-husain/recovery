import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/models/user_model.dart';
import 'package:recovery_app/resources/snack_bar.dart';
import 'package:recovery_app/resources/text_fiealds.dart';
import 'package:recovery_app/screens/BottomNav/bottom_nav.dart';
import 'package:recovery_app/screens/authentication/agency_code_screen.dart';
import 'package:recovery_app/screens/authentication/login.dart';
import 'package:recovery_app/screens/authentication/sign_up_screen.dart';
import 'package:recovery_app/screens/common_widgets/count_down_ui.dart';
import 'package:recovery_app/services/auth_services.dart';

class OtpLogin extends StatefulWidget {
  const OtpLogin({super.key});

  @override
  State<OtpLogin> createState() => _OtpLoginState();
}

class _OtpLoginState extends State<OtpLogin> with TickerProviderStateMixin {
  final TextEditingController _emailController =
      TextEditingController(text: "8766865570");
  String? otp;
  UserModel? user;
  var isCountComplete = false;
  late AnimationController _controller;
  int levelClock = 10; // Set your countdown time here

  void _startCountDown() {
    _controller = AnimationController(
        vsync: this, duration: Duration(seconds: levelClock));
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isCountComplete = true;
        });
      }
    });
  }

  void _restartCountdown() {
    setState(() {
      isCountComplete = false;
    });
    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                        if (_emailController.text.isEmpty) {
                          showSnackbar(
                            "Phone number is required",
                            context,
                            Icons.warning,
                          );
                          return;
                        }
                        var result = await AuthServices.verifyPhone(
                          phone: _emailController.text,
                          context: context,
                        );
                        otp = result.$1;
                        user = result.$2;
                        setState(() {});
                        _startCountDown();
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
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
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.of(context).push(MaterialPageRoute(
                    //         builder: (c) => const SignUpScreen()));
                    //   },
                    //   child: const Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Text("Don't have an account?"),
                    //       SizedBox(width: 5),
                    //       Text(
                    //         'Sign Up',
                    //         style: TextStyle(
                    //           color: Color(0xff2c65d8),
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //         maxLines: 1,
                    //       ),
                    //     ],
                    //   ),
                    // )
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
          'Enter the otp send to +91 ${_emailController.text}',
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
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: InkWell(
          onTap: () {
            setState(() {
              otp = null;
            });
          },
          child: Text(
            'Wrong Number?',
            style: GoogleFonts.outfit(
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.red,
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      const SizedBox(height: 20),
      OtpTextField(
        clearText: true,
        numberOfFields: 4,
        borderColor: const Color(0xFF512DA8),
        enabledBorderColor: const Color.fromARGB(255, 182, 152, 251),
        //set to true to show as box or false to show as dash
        showFieldAsBox: true,
        //runs when a code is typed in
        onCodeChanged: (String code) {
          //handle validation or checks here
        },
        //runs when every textfield is filled
        onSubmit: (v) {
          if (v == otp) {
            if (user != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BottomNavView()),
              );
              showSnackbar(
                  "Welcome back ${user!.agent_name}", context, Icons.warning);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AgencyCodeScreen(
                          phoneNumber: _emailController.text,
                        )),
              );
            }
          } else {
            showSnackbar("OTP is incorrect", context, Icons.warning);
          }
        }, // end onSubmit
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: GestureDetector(
          onTap: () async {
            if (_emailController.text.isEmpty) {
              showSnackbar(
                "Phone number is required",
                context,
                Icons.warning,
              );
              Navigator.of(context).pop();
              return;
            }
            var result = await AuthServices.verifyPhone(
              phone: _emailController.text,
              context: context,
            );
            otp = result.$1;
            user = result.$2;
            setState(() {});
            _restartCountdown();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Resend OTP?',
                style: TextStyle(
                  color:
                      isCountComplete ? const Color(0xff2c65d8) : Colors.grey,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Countdown(
                animation: StepTween(
                  begin: levelClock,
                  end: 0,
                ).animate(_controller),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 20),
    ];
  }
}
