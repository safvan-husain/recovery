import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/resources/snack_bar.dart';
import 'package:recovery_app/screens/authentication/otp_login.dart';
import 'package:recovery_app/screens/authentication/sign_up_screen.dart';
import 'package:recovery_app/services/auth_services.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController =
      TextEditingController(text: "vsah2@gmail.com");
  final TextEditingController _passwordController =
      TextEditingController(text: "12321");
  bool passwordObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 20),
                // Image.asset('assets/icons/logo.jpeg'),
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
                const SizedBox(height: 10),
                Text(
                  'Login with your email id',
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
                    _inputFieald(
                      controller: _emailController,
                      icon: Icons.mail_outline,
                      label: 'Email ID',
                    ),
                    _inputFieald(
                      controller: _passwordController,
                      label: "Password",
                      icon: Icons.lock_outline,
                      isSensitive: passwordObscure,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (c) => const OtpLogin()),
                              (route) => false,
                            );
                          },
                          child: const Text(
                            'Forgot Password ?',
                            style: TextStyle(
                              color: Color(0xff2c65d8),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
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
                  onPressed: () {
                    if (_emailController.text.isEmpty ||
                        _passwordController.text.isEmpty ||
                        _passwordController.text.isEmpty) {
                      showSnackbar(
                        "Every fiealds are required",
                        context,
                        Icons.no_encryption,
                      );
                      return;
                    }
                    AuthServices.loginUser(
                      userName: _userNameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
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
                    'Login',
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
                const SizedBox(height: 40),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (c) => const OtpLogin()));
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
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _inputFieald({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool? isSensitive,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.blue, width: 1.0)),
      child: TextFormField(
        style: GoogleFonts.poppins(color: Colors.black),
        controller: controller,
        obscureText: isSensitive ?? false,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xff23202a),
            fontSize: 16,
          ),
          suffixIcon: isSensitive == null
              ? null
              : InkWell(
                  onTap: () {
                    setState(() {
                      passwordObscure = !passwordObscure;
                    });
                  },
                  child: Icon(
                    passwordObscure ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
