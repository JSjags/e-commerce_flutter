import 'package:e_commerce/pages/login/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatelessWidget {

  final Function()? onTap;
  final Widget child;
  final bool padSides;

  const MyButton ({
    super.key,
    required this.onTap,
    required this.child,
    required this.padSides
});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        margin: EdgeInsets.symmetric(horizontal: padSides ? 25.0 : 0),
        decoration: BoxDecoration(color: const Color(0xff4F0000), borderRadius: BorderRadius.circular(8)),
        child: Center(
            child: child,
    )));
  }
}
