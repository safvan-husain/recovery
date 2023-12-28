import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget getDropDown<T>(
  T? currentValue, {
  required String hint,
  required List<T> values,
  required Function(T? newValue) onChanged,
}) {
  return Card(
    color: Colors.white,
    margin: const EdgeInsets.symmetric(vertical: 7),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            hint,
            style: GoogleFonts.poppins(fontSize: 12),
          ),
          SizedBox(
            height: 30,
            child: DropdownButton<T>(
              value: currentValue ?? values.first,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.grey,
              ),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              onChanged: onChanged,
              items: values.map<DropdownMenuItem<T>>((T value) {
                return DropdownMenuItem<T>(
                  value: value,
                  child: Text(value.toString().split('.').last),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    ),
  );
}
