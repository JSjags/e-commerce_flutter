import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/components/my_appbar.dart';
import 'package:e_commerce/components/my_bottom_nav_bar.dart';
import 'package:e_commerce/components/my_drawer.dart';
import 'package:e_commerce/pages/cart/ui/cart.dart';
import 'package:e_commerce/pages/search/ui/search.dart';
import 'package:e_commerce/pages/shop/ui/shop.dart';
import 'package:e_commerce/pages/wishlist/ui/wishlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Home extends StatefulWidget {
  final int page;
  const Home({Key? key, this.page = 0}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void Function()? signOutUser() {
    FirebaseAuth.instance.signOut();
  }

  var pageIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageIndex = widget.page;
  }

  final User user = FirebaseAuth.instance.currentUser!;

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

  void Function(int)? updatePageIndex(index) {
    setState(() {
      pageIndex = index;
    });
  }

  Widget figureScreen(int index) {
    Widget widgetScreen;

    switch(index) {
      case 0:
        widgetScreen = const Shop();
        break;
      case 1:
        widgetScreen = const WishList();
        break;
      case 2:
        widgetScreen = const Search();
        break;
      case 3:
        widgetScreen = const Cart();
        break;
      default:
        widgetScreen = const Shop();
        break;
    }

    return widgetScreen;
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots(), builder: (context, snapshot) {
      final List cart = snapshot.data?['cart'] ?? [];

      return Scaffold(
        backgroundColor: Colors.white,
        drawer: const MyDrawer(),
        appBar: MyAppBar(pageIndex: pageIndex),
        bottomNavigationBar: MyBottomNavBar(
            pageIndex: pageIndex, updatePageIndex: updatePageIndex, cart: cart),
        body: figureScreen(pageIndex),
      );

    });
  }
}
