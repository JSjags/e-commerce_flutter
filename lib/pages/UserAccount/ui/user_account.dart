import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/components/my_textfield.dart';
import 'package:e_commerce/pages/UserAccount/bloc/user_details_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({Key? key}) : super(key: key);

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  TextEditingController? nameController;
  TextEditingController? emailController;
  TextEditingController? phoneController;

  UserDetailsBloc userDetailsBloc = UserDetailsBloc();

  bool isBtnActive() {
    if (nameController!.text.trim().isEmpty ||
        phoneController!.text.trim().isEmpty) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<UserDetailsBloc, UserDetailsState>(
        bloc: userDetailsBloc,
        listenWhen: (previous, current) => current is UserDetailsActionState,
        buildWhen: (previous, current) => current is! UserDetailsActionState,
        listener: (context, state) {
          if(state is UserDetailsSuccessfullyUpdatedState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(
              content: Text(
                "Your personal information updated successfully",
                style: GoogleFonts.quicksand(
                    color: Colors.black54),
              ),
              padding:
              const EdgeInsets.only(left: 20),
              backgroundColor: Colors.cyan,
              dismissDirection:
              DismissDirection.down,
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: "DISMISS",
                textColor: Colors.amber,
                onPressed:
                ScaffoldMessenger.of(context)
                    .removeCurrentSnackBar,
              ),
              behavior: SnackBarBehavior.floating,
              elevation: 10,
              shape: const StadiumBorder(),
              margin: const EdgeInsets.only(
                  left: 10, right: 10, bottom: 80),
            ));
            userDetailsBloc.emit(UserDetailsInitial());
          } else if(state is UserDetailsUpdateErrorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(
              content: Text(
                "Error updating your personal information",
                style: GoogleFonts.quicksand(
                    color: Colors.white),
              ),
              padding: const EdgeInsets.only(left: 20),
              backgroundColor: Colors.red,
              dismissDirection: DismissDirection.down,
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: "DISMISS",
                textColor: Colors.amber,
                onPressed: ScaffoldMessenger.of(context)
                    .removeCurrentSnackBar,
              ),
              behavior: SnackBarBehavior.floating,
              elevation: 10,
              shape: const StadiumBorder(),
              margin: const EdgeInsets.only(
                  left: 10, right: 10, bottom: 80),
            ));
            userDetailsBloc.emit(UserDetailsInitial());
          }
        },

        builder: (context, state) {
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                final String? fullName = snapshot.data?['full_name'];
                final String? email = snapshot.data?['email'];
                final String? phoneNumber = snapshot.data?['phone-Number']??'';

                // set initial values for controllers
                nameController = TextEditingController(text: fullName??'');
                emailController = TextEditingController(text: email??'');
                phoneController = TextEditingController(text: phoneNumber??'');

                return GestureDetector(
                  onTap: () {
                    // FocusScopeNode currentFocus = FocusScope.of(context);
                    //
                    // if (!currentFocus.hasPrimaryFocus) {
                    //   currentFocus.unfocus();
                    // }
                  },
                  child: ListView(
                    children: [
                      Column(
                            children: [
                              const SizedBox(
                                height: 25.0,
                              ),
                              MyTextField(
                                controller: nameController!,
                                hintText: 'Full Name',
                                obscureText: false,
                                prefixIcon: Icons.credit_card_rounded,
                                padSides: true,

                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              MyTextField(
                                controller: emailController!,
                                hintText: 'Email',
                                obscureText: false,
                                prefixIcon: Icons.alternate_email_rounded,
                                padSides: true,
                                isEnabled: false,
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              MyTextField(
                                controller: phoneController!,
                                hintText: 'Phone Number',
                                obscureText: false,
                                prefixIcon: Icons.phone_android_rounded,
                                padSides: true,
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.error_outline_rounded,
                                        color: Color(0xff4F0000)),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Flexible(
                                      child: Text(
                                        "Please add your country code with your number e.g +2347034559393",
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.quicksand(
                                            color: const Color(0xff4F0000)),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            FilledButton(
                              onPressed: isBtnActive()
                                  ? null
                                  : () async {
                                userDetailsBloc.emit(SavingUserInformation());
                                try {
                                  final users = FirebaseFirestore.instance
                                      .collection('users');
                                  final docRef = users.doc(
                                      FirebaseAuth.instance.currentUser!.uid);

                                  /// send your request here
                                  // final bool success= await sendRequest();
                                  await docRef
                                      .get()
                                      .then((DocumentSnapshot doc) {
                                    if (doc.exists) {
                                      // Update address
                                      docRef.update({
                                        'full_name': nameController!.text,
                                        'phone_number': phoneController!.text
                                      }).then((value) {
                                        userDetailsBloc.emit(UserDetailsSuccessfullyUpdatedState());
                                        return true;
                                      });
                                    } else {
                                      print("User data already exists");
                                    }
                                  });
                                } catch (e) {
                                  userDetailsBloc.emit(UserDetailsUpdateErrorState());
                                }
                              },
                              child: state is SavingUserInformation ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white,strokeWidth: 2,)),
                                  SizedBox(width: 10,),
                                  Text(
                                    "Saving",
                                    style: GoogleFonts.quicksand(),
                                  )
                                ],
                              ) : Text(
                                "Save",
                                style: GoogleFonts.quicksand(),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              });

        });
  }
}
