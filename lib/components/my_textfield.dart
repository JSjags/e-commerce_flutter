import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final IconData prefixIcon;
  final bool padSides;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.prefixIcon,
    required this.padSides
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padSides ? 25.0 : 0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: GoogleFonts.quicksand(),
        decoration: InputDecoration(
          prefixIcon: Icon(prefixIcon, color: const Color(0xff4F0000).withOpacity(0.2),),
          hintText: hintText,
          hintStyle: GoogleFonts.quicksand(),
          filled: true,
          fillColor: Colors.grey[100],
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: const Color(0xff4F0000).withOpacity(0.2)),
              borderRadius: BorderRadius.circular(8.0)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xffE80011)),
              borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
    );
  }
}
