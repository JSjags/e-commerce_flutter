import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {

  final int pageIndex;
  const MyAppBar({super.key, required this.pageIndex});

  String figureTitle(int index) {
    String title;

    switch (index) {
      case 0:
        title = "Shop";
        break;
      case 1:
        title = "Wishlist";
        break;
      case 2:
        title = "Search";
        break;
      case 3:
        title = "Cart";
        break;
      default:
        title = "Home";
        break;
    }
    return title;
  }
  @override
  Size get preferredSize => const Size.fromHeight(60);
  @override

  Widget build(BuildContext context) {
    return  AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          figureTitle(pageIndex),
          style: GoogleFonts.quicksand(
              color: const Color(0xff4F0000), fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          Builder(builder: (context) {
            return Container(
                padding: const EdgeInsets.only(right: 15.0),
                child: GestureDetector(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: CircleAvatar(
                      backgroundColor: const Color(0xffE80011),
                      child: Text(
                        FirebaseAuth.instance.currentUser!.email
                            .toString()
                            .substring(0, 2)
                            .toUpperCase(),
                        style: GoogleFonts.quicksand(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    )));
          })
        ],
    );
  }
}
