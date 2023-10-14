import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart_outlined, size: 80,color: Colors.grey,),
            const SizedBox(height: 15.0,),
            Text("This is shop screen", style: GoogleFonts.quicksand(fontSize: 16, color: Colors.grey),)
          ],
        )
    );
  }
}
