import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildPhoneInputFieald({
  required TextEditingController controller,
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
    child: TextField(
      keyboardType: TextInputType.phone,
      inputFormatters: [LengthLimitingTextInputFormatter(10)],
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "phone",
        hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(
            top: 15,
            bottom: 8.0,
            right: 10,
          ),
          child: Text("🇮🇳  IN  +91"),
        ),
      ),
      controller: controller,
    ),
  );
}
