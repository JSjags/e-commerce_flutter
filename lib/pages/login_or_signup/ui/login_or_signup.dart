import 'package:e_commerce/pages/login/ui/login.dart';
import 'package:e_commerce/pages/signup/ui/signup.dart';
import 'package:flutter/material.dart';

class LoginOrSignup extends StatefulWidget {
  const LoginOrSignup({Key? key}) : super(key: key);

  @override
  State<LoginOrSignup> createState() => _LoginOrSignupState();
}

class _LoginOrSignupState extends State<LoginOrSignup> {
  bool showLoginPage = true;

  void togglePage() {
    setState(() {
      print(showLoginPage);
      showLoginPage = !showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginPage) {
      return Login(togglePage: togglePage);
    } else {
      return Signup(togglePage: togglePage);
    }
  }
}
