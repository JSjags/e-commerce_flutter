import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:badges/badges.dart' as badges;

class MyBottomNavBar extends StatelessWidget {
  final int pageIndex;
  final void Function(int)? updatePageIndex;
  final List cart;
  const MyBottomNavBar(
      {super.key, required this.pageIndex, required this.updatePageIndex, this.cart = const []});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff4F0000),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
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
            selectedIndex: pageIndex,
            tabs: [
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
                leading: Container(
                  child: badges.Badge(
                      position: badges.BadgePosition.topEnd(top: 0, end: -12),
                      showBadge: cart.isNotEmpty,
                      ignorePointer: false,
                      onTap: () {},
                      badgeContent:
                      Text(cart.length.toString(), style: GoogleFonts.quicksand(color: Colors.white),),
                      badgeAnimation: const badges.BadgeAnimation.scale(
                        animationDuration: Duration(seconds: 1),
                        colorChangeAnimationDuration: Duration(seconds: 1),
                        loopAnimation: false,
                        curve: Curves.fastOutSlowIn,
                        colorChangeAnimationCurve: Curves.easeInCubic,
                      ),
                      badgeStyle: badges.BadgeStyle(
                        shape: badges.BadgeShape.circle,
                        badgeColor: Colors.cyan,
                        padding: const EdgeInsets.all(5),
                        borderRadius: BorderRadius.circular(10),
                        elevation: 0,

                      ),
                      child: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 24,),
                    ),
                ),
              )
            ]),
      ),
    );
  }
}
