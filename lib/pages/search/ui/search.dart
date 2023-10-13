import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_rounded, size: 80,color: Colors.grey,),
            const SizedBox(height: 15.0,),
            Text("This is search screen", style: GoogleFonts.quicksand(fontSize: 16, color: Colors.grey),)
          ],
        )
    );
  }
}
