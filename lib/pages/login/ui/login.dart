import 'package:e_commerce/components/my_button.dart';
import 'package:e_commerce/components/my_textfield.dart';
import 'package:e_commerce/components/my_tilecard.dart';
import 'package:e_commerce/pages/forgot_password/ui/forgot_password.dart';
import 'package:e_commerce/pages/login/bloc/login_bloc.dart';
import 'package:e_commerce/services/user.dart' as user_actions;
import 'package:e_commerce/services/auth-service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  final Function()? togglePage;

  const Login({super.key, required this.togglePage});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  void signUserIn() async {
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
      // start signing in
      loginBloc.add(LoginButtonClickedEvent());

      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      loginBloc.close();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _absorb = false;
      });
      if (e.code == 'user-not-found') {
        setState(() => _errorMessage = "No user found for that email");
      } else if (e.code == "wrong-password") {
        setState(() => _errorMessage = "Wrong password");
      } else if (e.code == "invalid-email") {
        setState(() => _errorMessage = "Invalid email");
      } else if (e.code == "wrong-password") {
        setState(() => _errorMessage = "Wrong password");
      } else if (e.code == "invalid-email") {
        setState(() => _errorMessage = "Invalid email");
      } else if (e.code == "INVALID_LOGIN_CREDENTIALS") {
        setState(() => _errorMessage = "Invalid login credentials");
      } else if (e.code == "too-many-requests") {
        setState(() => _errorMessage =
            "Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.");
      } else if (e.code == "channel-error") {
        setState(() => _errorMessage =
            "Unable to login at the moment, please check your network connection");
      } else {
        setState(() => _errorMessage = "Error signing you in");
      }
      loginBloc.emit(UserLoginFailedState());
    } catch (e) {
      setState(() {
        _absorb = false;
      });
      loginBloc.emit(UserLoginFailedState());
      if (e.toString() == "Enter your email") {
        setState(() => _errorMessage = "Enter your email");
      } else if (e.toString() == "Enter your password") {
        setState(() => _errorMessage = "Enter your password");
      } else {
        setState(() => _errorMessage = e.toString());
      }
    }
  }

  void googleLogin() async {
    loginBloc.add(OAuthButtonClickedEvent());

    try {
      await AuthService().signInWithGoogle();
      await user_actions.User.addUserDetails(
          uid: FirebaseAuth.instance.currentUser!.uid,
          fullName: FirebaseAuth.instance.currentUser?.displayName ?? "",
          email: FirebaseAuth.instance.currentUser!.email ??
              emailController.text.trim());
    } on FirebaseAuthException catch (e) {
      loginBloc.emit(UserLoginFailedState());
      if (e.code == 'account-exists-with-different-credential') {
        setState(() =>
            _errorMessage = "This account exists with different credential");
      }
    } catch (e) {
      setState(() => _errorMessage =
          "Unable to login at the moment, please check your network connection");
      loginBloc.emit(UserLoginFailedState());
    }
  }

  void facebookLogin() async {
    loginBloc.add(OAuthButtonClickedEvent());

    try {
      await AuthService().signInWithFacebook();
      await user_actions.User.addUserDetails(
          uid: FirebaseAuth.instance.currentUser!.uid,
          fullName: FirebaseAuth.instance.currentUser?.displayName ?? "",
          email: FirebaseAuth.instance.currentUser!.email ??
              emailController.text.trim());
    } on FirebaseAuthException catch (e) {
      loginBloc.emit(UserLoginFailedState());
      if (e.code == 'account-exists-with-different-credential') {
        setState(() =>
            _errorMessage = "This account exists with different credential");
      }
    } catch (e) {
      setState(() => _errorMessage =
          "Unable to login at the moment, please check your network connection");
      loginBloc.emit(UserLoginFailedState());
    }
  }

  String _errorMessage = "";

  final LoginBloc loginBloc = LoginBloc();

  // Text Editing Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Disable screen when signing user in
  bool _absorb = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
        bloc: loginBloc,
        listener: (context, state) {
          //TODO: implement listener
        },
        listenWhen: (previous, current) => current is LoginActionState,
        buildWhen: (previous, current) => current is! LoginActionState,
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
                          height: 200,
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
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgotPassword()));
                                },
                                child: Text(
                                  "Forgot password?",
                                  style: GoogleFonts.quicksand(
                                      color: const Color(0xffE80011)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: state is UserLoginFailedState
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
                                      _errorMessage,
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
                            onTap: signUserIn,
                            padSides: true,
                            child: state is UserLoggingInState
                                ? Container(
                                    width: 24,
                                    height: 24,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text("Sign in",
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
                                color: const Color(0xff4F0000).withOpacity(0.2),
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
                            TileCard(
                                onTap: googleLogin,
                                imagePath: "lib/images/google.png"),
                            const SizedBox(
                              width: 15.0,
                            ),
                            // Apple login
                            // TileCard(onTap: () => {}, imagePath: "lib/images/apple.png"),
                            // const SizedBox(
                            //   width: 15.0,
                            // ),
                            // Facebook login
                            TileCard(
                                onTap: facebookLogin,
                                imagePath: "lib/images/facebook.png"),
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
                            const SizedBox(
                              width: 5.0,
                            ),
                            GestureDetector(
                              onTap: widget.togglePage,
                              child: Text(
                                "Sign up now",
                                style: GoogleFonts.quicksand(
                                    color: const Color(0xffE80011)),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ]),
                    ),
                  ),
                )),
          );
        });
  }
}
