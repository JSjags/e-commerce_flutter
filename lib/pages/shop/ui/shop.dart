import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.store, size: 80,color: Colors.grey,),
          const SizedBox(height: 15.0,),
          Text("This is shop screen", style: GoogleFonts.quicksand(fontSize: 16, color: Colors.grey),)
        ],
      )
    );
  }
}
