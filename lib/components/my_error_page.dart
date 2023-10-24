import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorPage extends StatelessWidget {
  final String message;
  const ErrorPage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, size: 80,color: Colors.grey,),
              const SizedBox(height: 15.0,),
              Text(message, textAlign: TextAlign.center, style: GoogleFonts.quicksand(fontSize: 16, color: Colors.grey),)
            ],
          ),
        )
    );
  }
}
