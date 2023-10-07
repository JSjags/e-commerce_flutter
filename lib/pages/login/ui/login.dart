import 'package:e_commerce/components/my_button.dart';
import 'package:e_commerce/components/my_textfield.dart';
import 'package:e_commerce/components/my_tilecard.dart';
import 'package:e_commerce/pages/login/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LoginBloc loginBloc = LoginBloc();

  // Text Editing Controllers
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
        bloc: loginBloc,
        listener: (context, state) {
          //TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
              body: SafeArea(
            child: Center(
              child: ListView(children: [
                Image.asset(
                  'lib/images/BuyOut.png',
                  height: 250,
                ),
                Center(
                  child: Text('Welcome back! You\'ve been missed',
                      style: GoogleFonts.quicksand(
                          color: const Color(0xff4F0000),
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                MyTextField(
                    controller: userNameController,
                    hintText: 'Username',
                    obscureText: false),
                const SizedBox(
                  height: 15.0,
                ),
                MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true),
                const SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Forgot password?",
                        style: GoogleFonts.quicksand(
                            color: const Color(0xffE80011)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                const MyButton(),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Divider(
                        height: 1,
                        color: Color(0xff4F0000).withOpacity(0.2),
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'or continue with',
                          style: GoogleFonts.quicksand(
                              color: const Color(0xff4F0000).withOpacity(0.8)),
                        ),
                      ),
                      Expanded(
                          child: Divider(
                        height: 1,
                        color: Color(0xff4F0000).withOpacity(0.2),
                      ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Google login
                    TileCard(imagePath: "lib/images/google.png"),
                    SizedBox(
                      width: 15.0,
                    ),
                    // Apple login
                    TileCard(imagePath: "lib/images/apple.png"),
                    SizedBox(
                      width: 15.0,
                    ),
                    // Facebook login
                    TileCard(imagePath: "lib/images/facebook.png"),
                  ],
                ),
                const SizedBox(
                  height: 25.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: GoogleFonts.quicksand(),
                    ),
                    const SizedBox(width: 5.0,),
                    Text("Sign up now", style: GoogleFonts.quicksand(color: const Color(0xffE80011)),)
                  ],
                )
              ]),
            ),
          ));
        });
  }
}
