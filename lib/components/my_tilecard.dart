import 'package:flutter/material.dart';

class TileCard extends StatelessWidget {
  final String imagePath;
  final Function()? onTap;

  const TileCard({super.key, required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60.0,
        height: 60.0,
        padding: const EdgeInsets.all(8.0),
        // color: Colors.grey[100],
        // decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Color(0xff4F0000).withOpacity(0.05)),
            color: Colors.grey[100]),
        child: Image.asset(
          imagePath,
          height: 40,
        ),
      ),
    );
  }
}
