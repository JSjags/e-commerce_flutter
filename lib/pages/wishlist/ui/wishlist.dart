import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WishList extends StatefulWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite, size: 80,color: Colors.grey,),
            const SizedBox(height: 15.0,),
            Text("This is wishlist screen", style: GoogleFonts.quicksand(fontSize: 16, color: Colors.grey),)
          ],
        ),
    );
  }
}
