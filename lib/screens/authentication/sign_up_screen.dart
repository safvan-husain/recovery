import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/resources/snack_bar.dart';
import 'package:recovery_app/services/auth_services.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isPasswordHide = true;
  bool isCPasswordHide = true;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool passwordObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const SizedBox(height: 30),
                // Text(
                //   'Welcome 👋',
                //   style: GoogleFonts.outfit(
                //     textStyle: const TextStyle(
                //       fontSize: 22,
                //       fontWeight: FontWeight.w600,
                //       color: Color(0xff2c65d8),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 10),
                Text(
                  'Provide your details here',
                  style: GoogleFonts.outfit(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff23202a),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _inputFieald(
                  controller: _userNameController,
                  icon: FontAwesomeIcons.user,
                  label: 'Full Name',
                ),
                _inputFieald(
                  controller: _emailController,
                  icon: Icons.mail_outline,
                  label: 'Email ID',
                ),
                _inputFieald(
                  controller: _addressController,
                  icon: FontAwesomeIcons.addressCard,
                  label: 'Address',
                ),
                _inputFieald(
                  controller: _passwordController,
                  label: "Password",
                  icon: Icons.lock_outline,
                  isSensitive: passwordObscure,
                ),
                _inputFieald(
                  controller: _confirmController,
                  label: "Confirm Password",
                  icon: Icons.lock_outline,
                  isSensitive: passwordObscure,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.blue, width: 1.0)),
                          child: Text(
                            "Pick Pan Card",
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.blue, width: 1.0)),
                          child: Text(
                            "Pick Adhar Card",
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_emailController.text.isEmpty ||
                        _passwordController.text.isEmpty ||
                        _userNameController.text.isEmpty ||
                        _passwordController.text.isEmpty ||
                        _confirmController.text.isEmpty) {
                      showSnackbar(
                        "Every fieald required",
                        context,
                        FontAwesomeIcons.fill,
                        Colors.redAccent,
                      );
                      return;
                    }
                    if (_passwordController.text != _confirmController.text) {
                      showSnackbar(
                        "Password mismatch",
                        context,
                        FontAwesomeIcons.cancel,
                        Colors.redAccent,
                      );
                      return;
                    }
                    AuthServices.registerUser(
                      userName: _userNameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                      context: context,
                    );
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 70,
                      ), // Adjust the padding here
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
                    'Sign Up',
                    maxLines: 1,
                    style: GoogleFonts.outfit(
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?"),
                      SizedBox(width: 5),
                      Text(
                        'Log In',
                        style: TextStyle(
                          color: Color(0xff2c65d8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
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
        controller: controller,
        obscureText: isSensitive ?? false,
        style: GoogleFonts.poppins(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
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
