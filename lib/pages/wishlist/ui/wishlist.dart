import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/data/theme.dart';
import 'package:e_commerce/pages/product_details/ui/product_details.dart';
import 'package:e_commerce/pages/wishlist/bloc/wishlist_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class WishList extends StatefulWidget {
  const WishList({Key? key}) : super(key: key);

  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  WishlistBloc wishlistBloc = WishlistBloc();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WishlistBloc, WishlistState>(
        bloc: wishlistBloc,
        listenWhen: (previous, current) => current is WishlistActionState,
        buildWhen: (previous, current) => current is! WishlistActionState,
        listener: (context, state) {
          if (state is NavigateToProductDetailsState) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductDetails(
                        category: state.category,
                        productIndex: state.productIndex)));
          }
        },
        builder: (context, state) {
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List wishlist = snapshot.data!['wishlist'];
                  if (wishlist.isNotEmpty) {
                    return ListView.builder(
                      itemCount: wishlist.length,
                      padding: const EdgeInsets.all(20),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => wishlistBloc.add(
                              ShopItemTileClickedEvent(
                                  category: wishlist[index]['category'],
                                  productIndex: wishlist[index]['id'])),
                          child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(
                                      5.0,
                                      5.0,
                                    ),
                                    blurRadius: 10.0,
                                    spreadRadius: 2.0,
                                  ), //BoxShadow
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 0.0),
                                    blurRadius: 0.0,
                                    spreadRadius: 0.0,
                                  ), //// BoxShadow
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Image.network(
                                    wishlist[index]['image'],
                                    width: 70,
                                    height: 70,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${wishlist[index]['title']}\n',
                                            style: GoogleFonts.quicksand(
                                                fontWeight: FontWeight.bold),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '\$${wishlist[index]['price'].toStringAsFixed(2)}',
                                                style: GoogleFonts.quicksand(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                  Text(
                                                    '${wishlist[index]['rating']["rate"]}',
                                                    style:
                                                        GoogleFonts.quicksand(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.hourglass_empty_sharp,
                            size: 80,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            "There are no items in your wishlist",
                            style: GoogleFonts.quicksand(
                                fontSize: 16, color: Colors.grey),
                          )
                        ],
                      ),
                    );
                  }
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          size: 80,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          "Oops! Nothing to show here.",
                          style: GoogleFonts.quicksand(
                              fontSize: 16, color: Colors.grey),
                        )
                      ],
                    ),
                  );
                }
              });
        });
  }
}
