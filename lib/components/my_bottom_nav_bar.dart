import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavBar extends StatelessWidget {
  final int pageIndex;
  final void Function(int)? updatePageIndex;
  const MyBottomNavBar(
      {super.key, required this.pageIndex, required this.updatePageIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff4F0000),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: GNav(
            onTabChange: (index) => updatePageIndex!(index),
            rippleColor:
                (Colors.grey[800])!, // tab button ripple color when pressed
            hoverColor: (Colors.grey[700])!, // tab button hover color
            haptic: true, // haptic feedback
            tabBorderRadius: 25,
            // tabActiveBorder: Border.all(color: Colors.black, width: 1), // tab button border
            // tabBorder: Border.all(color: Colors.grey, width: 1), // tab button border
            // tabShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)], // tab button shadow
            // curve: Curves.easeOutExpo, // tab animation curves
            duration: const Duration(milliseconds: 500),
            // tab animation duration
            gap: 8, // the tab button gap between icon and text
            color: Colors.white, // unselected icon color
            activeColor: Colors.white, // selected icon and text color
            iconSize: 24, // tab button icon size
            textStyle: GoogleFonts.quicksand(color: Colors.white),
            tabBackgroundColor:
                const Color(0xffE80011), // selected tab background color
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 10), // navigation bar padding
            tabs: const [
              GButton(
                icon: Icons.store_mall_directory_rounded,
                text: 'Shop',
              ),
              GButton(
                icon: Icons.favorite_border_rounded,
                text: 'Wishlist',
              ),
              GButton(
                icon: Icons.search,
                text: 'Search',
              ),
              GButton(
                icon: Icons.shopping_cart_outlined,
                text: 'Cart',
              )
            ]),
      ),
    );
  }
}
