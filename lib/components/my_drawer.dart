import 'package:e_commerce/pages/messages/ui/messages.dart';
import 'package:e_commerce/pages/notifications/ui/notifications.dart';
import 'package:e_commerce/pages/orders/ui/orders.dart';
import 'package:e_commerce/pages/profile/ui/profile.dart';
import 'package:e_commerce/pages/settings/ui/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xff4F0000),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.cyanAccent,
                    child: Text(
                      FirebaseAuth.instance.currentUser!.email
                          .toString()
                          .substring(0, 2)
                          .toUpperCase(),
                      style: GoogleFonts.quicksand(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff4F0000)),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          FirebaseAuth.instance.currentUser!.email
                              .toString()
                              .trim(),
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(children: [
                          Icon(
                            FirebaseAuth.instance.currentUser!.emailVerified
                                ? Icons.verified_rounded
                                : Icons.error,
                            color:
                                FirebaseAuth.instance.currentUser!.emailVerified
                                    ? Colors.green
                                    : Colors.white60,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            FirebaseAuth.instance.currentUser!.emailVerified
                                ? "Verified"
                                : "Not verified",
                            style: GoogleFonts.quicksand(
                                color: FirebaseAuth
                                        .instance.currentUser!.emailVerified
                                    ? Colors.green
                                    : Colors.white30),
                          )
                        ])
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Divider(
                height: 1.0,
                color: Colors.white,
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextButton(
                onPressed: () => {
                  Scaffold.of(context).closeDrawer(),
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Orders()))
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.delivery_dining,
                      size: 28,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      "Orders",
                      style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextButton(
                onPressed: () => {
                  Scaffold.of(context).closeDrawer(),
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Messages()))
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.message_rounded,
                      size: 28,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      "Messages",
                      style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextButton(
                onPressed: () => {
                  Scaffold.of(context).closeDrawer(),
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Notifications()))
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.notifications_rounded,
                      size: 28,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      "Notifications",
                      style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextButton(
                onPressed: () => {
                  Scaffold.of(context).closeDrawer(),
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Profile()))
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.account_circle_rounded,
                      size: 28,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      "Profile",
                      style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextButton(
                onPressed: () => {
                  Scaffold.of(context).closeDrawer(),
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Settings()))
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.settings,
                      size: 28,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      "Settings",
                      style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => FirebaseAuth.instance.signOut(),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.logout_rounded,
                            size: 28,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 10.0),
                          Text(
                            "Log out",
                            style: GoogleFonts.quicksand(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
