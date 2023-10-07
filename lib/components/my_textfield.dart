import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
  required this.controller,
    required this.hintText,
    required this.obscureText,
});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: GoogleFonts.quicksand(),
        decoration: InputDecoration(
          hintText: hintText,
            hintStyle: GoogleFonts.quicksand(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff4F0000))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffE80011)))),
      ),
    );
  }
}
