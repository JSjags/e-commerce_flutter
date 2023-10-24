import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/components/my_error_page.dart';
import 'package:e_commerce/components/my_textfield.dart';
import 'package:e_commerce/data/theme.dart';
import 'package:e_commerce/pages/address/bloc/address_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class Address extends StatefulWidget {
  const Address({Key? key}) : super(key: key);

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();
  TextEditingController address2Controller = TextEditingController();

  AddressBloc addressBloc = AddressBloc();

  bool isBtnActive() {
    if (countryController!.text.trim().isEmpty ||
        stateController!.text.trim().isEmpty ||
        address1Controller!.text.trim().isEmpty) {
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressBloc, AddressState>(
        bloc: addressBloc,
        listenWhen: (previous, current) => current is AddressActionState,
        buildWhen: (previous, current) =>
            current is! AddressActionState || current is FocusScopeNode,
        listener: (context, state) {
          if (state is AddressSuccessfullyUpdatedState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "Address information updated successfully",
                style: GoogleFonts.quicksand(color: Colors.black54),
              ),
              padding: const EdgeInsets.only(left: 20),
              backgroundColor: Colors.cyan,
              dismissDirection: DismissDirection.down,
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: "DISMISS",
                textColor: Colors.amber,
                onPressed: ScaffoldMessenger.of(context).removeCurrentSnackBar,
              ),
              behavior: SnackBarBehavior.floating,
              elevation: 10,
              shape: const StadiumBorder(),
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 80),
            ));
            addressBloc.emit(AddressInitial());
          } else if (state is AddressUpdateErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "Error updating address information",
                style: GoogleFonts.quicksand(color: Colors.white),
              ),
              padding: const EdgeInsets.only(left: 20),
              backgroundColor: Colors.red,
              dismissDirection: DismissDirection.down,
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: "DISMISS",
                textColor: Colors.amber,
                onPressed: ScaffoldMessenger.of(context).removeCurrentSnackBar,
              ),
              behavior: SnackBarBehavior.floating,
              elevation: 10,
              shape: const StadiumBorder(),
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 80),
            ));
            addressBloc.emit(AddressInitial());
          }
        },
        builder: (context, state) {
          return FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final Map? address = snapshot.data?['address'];

                  // set initial values for controllers
                  countryController.text = address?['country'] ?? '';
                  stateController.text = address?['state'] ?? '';
                  address1Controller.text = address?['address1'] ?? '';
                  address2Controller.text = address?['address2'] ?? '';

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
                              controller: countryController!,
                              hintText: 'Country*',
                              obscureText: false,
                              prefixIcon: Icons.map_rounded,
                              padSides: true,
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            MyTextField(
                              controller: stateController!,
                              hintText: 'State*',
                              obscureText: false,
                              prefixIcon: Icons.location_on_outlined,
                              padSides: true,
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            MyTextField(
                              controller: address1Controller!,
                              hintText: 'Address 1*',
                              obscureText: false,
                              prefixIcon: Icons.location_city_rounded,
                              padSides: true,
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            MyTextField(
                              controller: address2Controller!,
                              hintText: 'Address 2',
                              obscureText: false,
                              prefixIcon: Icons.location_city_rounded,
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
                                      "Fields marked with * are required.",
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
                                        addressBloc
                                            .emit(SavingAddressInformation());
                                        try {
                                          final users = FirebaseFirestore
                                              .instance
                                              .collection('users');
                                          final docRef = users.doc(FirebaseAuth
                                              .instance.currentUser!.uid);

                                          /// send your request here
                                          // final bool success= await sendRequest();
                                          await docRef
                                              .get()
                                              .then((DocumentSnapshot doc) {
                                            if (doc.exists) {
                                              // Update address
                                              docRef.update({
                                                'address': {
                                                  "country":
                                                      countryController!.text,
                                                  "state":
                                                      stateController!.text,
                                                  "address1":
                                                      address1Controller!.text,
                                                  "address2":
                                                      address2Controller!.text,
                                                }
                                              }).then((value) {
                                                addressBloc.emit(
                                                    AddressSuccessfullyUpdatedState());
                                                return true;
                                              });
                                            } else {
                                              print("User data already exists");
                                            }
                                          });
                                        } catch (e) {
                                          addressBloc
                                              .emit(AddressUpdateErrorState());
                                        }
                                      },
                                child: state is SavingAddressInformation
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Saving",
                                            style: GoogleFonts.quicksand(),
                                          )
                                        ],
                                      )
                                    : Text(
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
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return const ErrorPage(
                      message: "Unable to load your data at the moment.");
                }
              });
        });
  }
}
