import 'package:e_commerce/pages/auth/ui/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentSuccess extends StatelessWidget {
  final String message;
  const PaymentSuccess({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xff4F0000),)),
        centerTitle: true,
        title: Text("Payment Successful", style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, color: const Color(0xff4F0000)),),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.done, size: 80,color: Colors.green,),
              const SizedBox(height: 15.0,),
              Flexible(child: Text(message, textAlign: TextAlign.center, style: GoogleFonts.quicksand(fontSize: 16, color: const Color(0xff4F0000), fontWeight: FontWeight.bold
              ),)),
              const SizedBox(height: 20,),
              FilledButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthPage())) , child: Text("Back to Shop", style: GoogleFonts.quicksand(),))
            ],
          )
      ),
    );
  }
}
