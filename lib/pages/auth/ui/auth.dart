import 'package:e_commerce/pages/home/ui/home.dart';
import 'package:e_commerce/pages/login/ui/login.dart';
import 'package:e_commerce/pages/login_or_signup/ui/login_or_signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
      //  user is logged in
        if(snapshot.hasData) {
          return Home();
        }
        else {
          return const LoginOrSignup();
        }
      },),
    );
  }
}
