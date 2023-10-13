import 'package:e_commerce/components/my_button.dart';
import 'package:e_commerce/components/my_textfield.dart';
import 'package:e_commerce/components/my_tilecard.dart';
import 'package:e_commerce/pages/login/ui/login.dart';
import 'package:e_commerce/pages/signup/bloc/signup_bloc.dart';
import 'package:e_commerce/services/auth-service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class Signup extends StatefulWidget {
  final Function()? togglePage;

  const Signup({super.key, required this.togglePage});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  void signUserUp() async {
    setState(() {
      _absorb = true;
    });

    // try sign in
    try {
      if (emailController.text.trim().isEmpty) {
        throw "Enter your email";
        return;
      }
      if (passwordController.text.trim().isEmpty) {
        throw "Enter your password";
        return;
      }
      if (confirmPasswordController.text.trim().isEmpty) {
        throw "Confirm your password";
        return;
      }

      if (passwordController.text.trim() == confirmPasswordController.text.trim()) {
        signupBloc.add(SignupButtonClickedEvent());
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        // signupBloc.close();
      } else {
        throw "Passwords don't match";
        return;
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _absorb = false;
      });
      if (e.code == 'email-already-in-use') {
        setState(() => _errorMessage = "This email is taken"
        );
      } else if (e.code == "weak-password") {
        setState(() => _errorMessage = "Password must be at least 6 characters"
        );
      } else if (e.code == "invalid-email") {
        setState(() => _errorMessage = "Invalid email"
        );
      } else if (e.code == "INVALID_LOGIN_CREDENTIALS") {
        setState(() => _errorMessage = "Invalid login credentials"
        );
      } else if (e.code == "too-many-requests") {
        setState(() => _errorMessage = "Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.");
      } else {
        print("hello: " + e.code);
        setState(() => _errorMessage = "Error signing you in"
        );
      }
      signupBloc.emit(UserSignupFailedState());
    } catch (e) {
      setState(() {
        _absorb = false;
      });
      signupBloc.emit(UserSignupFailedState());
      if (e.toString() == "Enter your email") {
        setState(() => _errorMessage = "Enter your email");
      } else if (e.toString() == "Enter your password") {
        setState(() => _errorMessage = "Enter your password");
      } else if (e.toString() == "Confirm your password") {
        setState(() => _errorMessage = "Confirm your password");
      } else if (e.toString() == "Passwords don't match") {
        setState(() => _errorMessage = "Passwords don't match");
      } else {
        setState(() => _errorMessage = e.toString());
      }
    }
  }

  void googleLogin() async {

    signupBloc.add(OAuthButtonClickedEvent());

    try {
      await AuthService().signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      signupBloc.emit(UserSignupFailedState());
      if (e.code == 'account-exists-with-different-credential') {
        setState(() => _errorMessage = "This account exists with different credential");
      }
    } catch (e) {
      setState(() => _errorMessage =
      "Unable to login at the moment, please check your network connection");
      signupBloc.emit(UserSignupFailedState());
    }
  }

  void facebookLogin() async {

    signupBloc.add(OAuthButtonClickedEvent());

    try {
      await AuthService().signInWithFacebook();
    } on FirebaseAuthException catch (e) {
      signupBloc.emit(UserSignupFailedState());
      if (e.code == 'account-exists-with-different-credential') {
        setState(() => _errorMessage = "This account exists with different credential");
      }
    } catch (e) {
      setState(() => _errorMessage =
      "Unable to login at the moment, please check your network connection");
      signupBloc.emit(UserSignupFailedState());
    }
  }

  String _errorMessage = "";
  final SignupBloc signupBloc = SignupBloc();

// Text Editing Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Disable screen when signing user in
  bool _absorb = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupBloc, SignupState>(
      bloc: signupBloc,
      listenWhen: (previous, current) => current is SignupActionState,
      buildWhen: (previous, current) => current is !SignupActionState,
      listener: (context, state) {},
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
              backgroundColor: Colors.white,
              body: AbsorbPointer(
                absorbing: _absorb,
                child: SafeArea(
                  child: Center(
                    child: ListView(children: [
                      Image.asset(
                        'lib/images/BuyOut.png',
                        height: 160,
                      ),
                      Center(
                        child: Text('Let\'s create an account for you!' ,
                            style: GoogleFonts.quicksand(
                                color: const Color(0xff4F0000),
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      MyTextField(
                          controller: emailController,
                          hintText: 'Email',
                          obscureText: false,
                          prefixIcon: Icons.alternate_email_outlined, padSides: true,),
                      const SizedBox(
                        height: 15.0,
                      ),
                      MyTextField(
                          controller: passwordController,
                          hintText: 'Password',
                          obscureText: true,
                          prefixIcon: Icons.lock_outline, padSides: true,),
                      const SizedBox(
                        height: 15.0,
                      ),
                      MyTextField(
                          controller: confirmPasswordController,
                          hintText: 'Confirm password',
                          obscureText: true,
                          prefixIcon: Icons.lock_outline, padSides: true,),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const SizedBox(height: 10.0,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: state is UserSignupFailedState ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.error_outline_rounded, color: Colors.red, size: 20.0,),
                            const SizedBox(width: 5.0,),
                            Flexible(child: Text(_errorMessage, style: GoogleFonts.quicksand(color: Colors.red),))
                          ],) : const SizedBox(),
                      ),
                      const SizedBox(height: 15.0,),
                      MyButton(
                          onTap: signUserUp,
                          padSides: true,
                          child: state is UserSigningUpState
                              ? Container(
                            width: 24,
                            height: 24,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                              : Text("Sign up",
                              style: GoogleFonts.quicksand(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18))),
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
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Or continue with',
                                style: GoogleFonts.quicksand(
                                    color: const Color(0xff4F0000)
                                        .withOpacity(0.8)),
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
                          TileCard(onTap: googleLogin, imagePath: "lib/images/google.png"),
                          const SizedBox(
                            width: 15.0,
                          ),
                          // Apple login
                          // TileCard(onTap: () => {}, imagePath: "lib/images/apple.png"),
                          // const SizedBox(
                          //   width: 15.0,
                          // ),
                          // Facebook login
                          TileCard(onTap: facebookLogin, imagePath: "lib/images/facebook.png"),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: GoogleFonts.quicksand(),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          GestureDetector(
                            onTap: widget.togglePage,
                            child: Text(
                              "Sign in now",
                              style: GoogleFonts.quicksand(
                                  color: const Color(0xffE80011)),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20,)
                    ]),
                  ),
                ),
              )),
        );
      },
    );
  }
}
