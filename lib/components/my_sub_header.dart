import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubHeader extends StatelessWidget {
  final String content;

  const SubHeader({
    super.key,
    required this.content
});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: GoogleFonts.quicksand(
          fontWeight: FontWeight.bold, fontSize: 16),
    );
  }
}
