import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final IconData prefixIcon;
  final bool padSides;
  final double paddingValue;
  final Function(String)? handleSearch;
  final Bloc? searchBloc;
  final String? initialValue;
  final bool isEnabled;
  final bool? isSearchPage;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.prefixIcon,
    required this.padSides,
    this.paddingValue = 25.0,
    this.handleSearch,
    this.searchBloc,
    this.initialValue,
    this.isEnabled = true,
    this.isSearchPage,
  });


  @override
  Widget build(BuildContext context) {
  print(isSearchPage);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padSides ? paddingValue : 0),
      child: TextField(
        controller: controller,
        onChanged: isSearchPage != null ? (value) => handleSearch!(value) : (value){},
        obscureText: obscureText,
        style: GoogleFonts.quicksand(),
        enabled: isEnabled,
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
