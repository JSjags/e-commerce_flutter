import 'package:e_commerce/components/my_button.dart';
import 'package:e_commerce/components/my_textfield.dart';
import 'package:e_commerce/pages/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:e_commerce/pages/login_or_signup/ui/login_or_signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String emailErrorMessage = "";

  final ForgotPasswordBloc forgotPasswordBloc = ForgotPasswordBloc();

  final TextEditingController emailController = TextEditingController();

  Future resetPassword() async {
    forgotPasswordBloc.add(ResetPasswordButtonClickedEvent());

    // empty email field
    if (emailController.text.trim().isEmpty) {
      forgotPasswordBloc.add(ResetPasswordFailedEvent());
      setState(() {
        emailErrorMessage = "Please enter your email";
      });
    }

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      _showDialog();
      forgotPasswordBloc.add(PasswordResetSuccessfulEvent());
      emailController.clear();
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'email-already-in-use') {
        setState(() => emailErrorMessage = "This email is taken");
      } else if (e.code == "invalid-email") {
        setState(() => emailErrorMessage = "Invalid email");
      } else if (e.code == "INVALID_LOGIN_CREDENTIALS") {
        setState(() => emailErrorMessage = "Invalid login credentials");
      } else if (e.code == "too-many-requests") {
        setState(() => emailErrorMessage =
            "Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.");
      } else {
        setState(() => emailErrorMessage = e.message.toString());
      }
      forgotPasswordBloc.emit(ResetPasswordFailedState());
    } catch (e) {
      print("Eweliwe: " + e.toString());
      forgotPasswordBloc.emit(ResetPasswordFailedState());
      if (e.toString() == "Enter your email") {
        setState(() => emailErrorMessage = "Enter your email");
      } else {
        setState(() => emailErrorMessage = e.toString());
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  // Success dialog
  void _showDialog() {
    showDialog(context: context, builder: (context) {
      return
        AlertDialog(
          title: Center(
              child: Text(
                "Email Sent",
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff4F0000),
                ),
              )),
          backgroundColor: Colors.white,
          elevation: 10.0,
          content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(40.0)),
                    child: const Icon(
                      Icons.done_rounded,
                      size: 80.0,
                      color: Colors.white,
                    )),
                const SizedBox(
                  height: 25.0,
                ),
                Text(
                  "Congratulations! Check your mailbox, you should have received password reset link.",
                  style: GoogleFonts.quicksand(
                      color: const Color(0xff4F0000)),
                )
              ],
            ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginOrSignup()));
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: const Color(0xff4F0000),
                    borderRadius: BorderRadius.circular(8.0)),
                child: Text(
                  "Back to login",
                  style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            )
          ],
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        bloc: forgotPasswordBloc,
        listenWhen: (previous, current) => current is ForgotPasswordActionState,
        buildWhen: (previous, current) => current is! ForgotPasswordActionState,
        listener: (context, state) {
          if (state is BackToLoginClickedState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                leading: IconButton(
                    onPressed: () =>
                        forgotPasswordBloc.add(BackToLoginClickedEvent()),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Color(0xff4F0000),
                    )),
                backgroundColor: Colors.white,
                title: Text(
                  "Forgot Password",
                  style: GoogleFonts.quicksand(
                      color: const Color(0xff4F0000),
                      fontWeight: FontWeight.w700),
                ),
              ),
              body: Center(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Icon(Icons.lock_outline_rounded,
                        size: 100.0,
                        color: const Color(0xffE80011).withOpacity(0.7)),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Let's get you a new password!",
                      style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff4F0000)),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Enter your email and we'll send you a password reset link.",
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        color: const Color(0xff4F0000),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    MyTextField(
                        controller: emailController,
                        hintText: "Email",
                        obscureText: false,
                        prefixIcon: Icons.alternate_email_rounded,
                        padSides: false),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: state is ResetPasswordFailedState
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.error_outline_rounded,
                                  color: Colors.red,
                                  size: 20.0,
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Flexible(
                                    child: Text(
                                  emailErrorMessage,
                                  style: GoogleFonts.quicksand(
                                    color: Colors.red,
                                  ),
                                ))
                              ],
                            )
                          : const SizedBox(),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    MyButton(
                        onTap: resetPassword,
                        padSides: false,
                        child: state is ResetPasswordButtonClickedState
                            ? Container(
                                width: 24,
                                height: 24,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Text("Reset Password",
                                style: GoogleFonts.quicksand(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
