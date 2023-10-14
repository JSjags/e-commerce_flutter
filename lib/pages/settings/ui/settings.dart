import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xff4F0000),)),
        centerTitle: true,
        title: Text("Settings", style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, color: const Color(0xff4F0000)),),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.settings, size: 80,color: Colors.grey,),
              const SizedBox(height: 15.0,),
              Text("This is settings screen", style: GoogleFonts.quicksand(fontSize: 16, color: Colors.grey),)
            ],
          )
      ),
    );
  }
}
