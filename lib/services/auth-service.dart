import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/services/user.dart' as user_actions;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
//  Google sign in
  signInWithGoogle() async {
    // begin interactive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    print('-------------------------${gUser?.displayName}');

    // obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // create a new credential for user
    final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken, idToken: gAuth.idToken);

    // finally, sign user in
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  signInWithFacebook() async {
    // begin interactive sign in process
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // obtain auth details from request
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // finally, sign user in with credential
    await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }
}
