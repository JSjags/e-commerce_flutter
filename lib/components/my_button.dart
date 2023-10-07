import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatelessWidget {
  const MyButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.symmetric(horizontal: 25.0),
      decoration: BoxDecoration(color: Color(0xff4F0000), borderRadius: BorderRadius.circular(8)),
      child: Center(
          child: Text("Sign in",
              style: GoogleFonts.quicksand(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
    );
  }
}
