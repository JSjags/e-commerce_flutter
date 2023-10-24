import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/models/Product.dart';
import 'package:e_commerce/pages/category/bloc/category_bloc.dart';
import 'package:e_commerce/pages/search/bloc/search_bloc.dart';
import 'package:e_commerce/pages/shop/bloc/shop_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopItemTile extends StatefulWidget {
  final Product product;
  final Bloc currentBloc;
  final List cart;
  final BuildContext context;

  const ShopItemTile(
      {super.key,
      required this.product,
      required this.currentBloc,
      required this.cart,
      required this.context});

  @override
  State<ShopItemTile> createState() => _ShopItemTileState();
}

class _ShopItemTileState extends State<ShopItemTile> {
  Future addToCart(Product product) async {
    final users = FirebaseFirestore.instance.collection('users');
    final docRef = users.doc(FirebaseAuth.instance.currentUser!.uid);

    /// send your request here
    // final bool success= await sendRequest();
    await docRef.get().then((DocumentSnapshot doc) {
      if (doc.exists) {
        final copiedData = doc.data() as Map<String, dynamic>;
        final List cart = copiedData['cart'];

        // Add to cart
        cart.add(product.toJson());
        docRef.update({'cart': cart}).then((value) {
          ScaffoldMessenger.of(widget.context).showSnackBar(SnackBar(
            content: Text(
              "Item added to cart",
              style: GoogleFonts.quicksand(color: Colors.black54),
            ),
            padding: const EdgeInsets.only(left: 20),
            backgroundColor: Colors.cyan,
            dismissDirection: DismissDirection.down,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: "DISMISS",
              textColor: Colors.amber,
              onPressed:
                  ScaffoldMessenger.of(widget.context).removeCurrentSnackBar,
            ),
            behavior: SnackBarBehavior.floating,
            elevation: 10,
            shape: const StadiumBorder(),
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 80),
          ));
          return true;
        });
      } else {
        print("User data already exists");
      }
    });
  }

  String countItemsInCart() {
    List filter = [];
    filter.addAll(widget.cart);

    filter.retainWhere(
        (element) => element['id'].toString() == widget.product.id.toString());

    return filter.length.toString();
  }

  Future removeFromCart(Product product) async {
    final users = FirebaseFirestore.instance.collection('users');
    final docRef = users.doc(FirebaseAuth.instance.currentUser!.uid);

    /// send your request here
    // final bool success= await sendRequest();
    await docRef.get().then((DocumentSnapshot doc) {
      if (doc.exists) {
        final copiedData = doc.data() as Map<String, dynamic>;
        final List cart = copiedData['cart'];

        // Remove from wishlist
        if ((cart.firstWhere(
                (element) => element['id'].toString() == product.id.toString(),
                orElse: () => null)) !=
            null) {
          final itemToRemove = cart.firstWhere(
              (element) => element['id'].toString() == product.id.toString(),
              orElse: () => null);

          cart.remove(itemToRemove);
          docRef.update({'cart': cart}).then((value) {
            ScaffoldMessenger.of(widget.context).showSnackBar(SnackBar(
              content: Text(
                "Item removed from cart",
                style: GoogleFonts.quicksand(color: Colors.black54),
              ),
              padding: const EdgeInsets.only(left: 20),
              backgroundColor: Colors.orange,
              dismissDirection: DismissDirection.down,
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: "DISMISS",
                textColor: Colors.amber,
                onPressed:
                    ScaffoldMessenger.of(widget.context).removeCurrentSnackBar,
              ),
              behavior: SnackBarBehavior.floating,
              elevation: 10,
              shape: const StadiumBorder(),
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 80),
            ));
            return true;
          });
        } else {
          // Add to wishlist
          docRef.update({
            'cart': FieldValue.arrayUnion([product.toJson()])
          }).then((value) {
            ScaffoldMessenger.of(widget.context).showSnackBar(SnackBar(
              content: Text(
                "Item added to cart",
                style: GoogleFonts.quicksand(color: Colors.black54),
              ),
              padding: const EdgeInsets.only(left: 20),
              backgroundColor: Colors.cyan,
              dismissDirection: DismissDirection.down,
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: "DISMISS",
                textColor: Colors.amber,
                onPressed:
                    ScaffoldMessenger.of(widget.context).removeCurrentSnackBar,
              ),
              behavior: SnackBarBehavior.floating,
              elevation: 10,
              shape: const StadiumBorder(),
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 80),
            ));
            return true;
          });
        }
      } else {
        print("User data already exists");
      }
    }, onError: (e) => throw e);
  }

  @override
  Widget build(BuildContext context) {
    List filter = [];

    return GestureDetector(
      onTap: () {
        if(widget.currentBloc is ShopBloc) {
          widget.currentBloc.add(ShopItemTileClickedEvent(
              category: widget.product.category,
              productIndex: widget.product.id));
        } else if(widget.currentBloc is SearchBloc) {
          widget.currentBloc.add(SearchItemTileClickedEvent(
              category: widget.product.category,
              productIndex: widget.product.id));
        } else {
          widget.currentBloc.add(CategoryItemTileClickedEvent(
              category: widget.product.category,
              productIndex: widget.product.id));
        }
      },
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  offset: const Offset(
                    5.0,
                    5.0,
                  ),
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                ), //BoxShadow
                BoxShadow(
                  color: Colors.grey.shade400,
                  offset: const Offset(0.0, 0.0),
                  blurRadius: 5.0,
                  spreadRadius: 0.0,
                ), //BoxShadow
              ]),
          // width: 200,
          // height: 160,
          child: Column(
            children: [
              // Thumbnail
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                width: double.maxFinite,
                child: Image.network(
                  widget.product.image,
                  fit: BoxFit.contain,
                  height: 100,
                ),
              ),
              // Details
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.product.title}\n',
                        style:
                            GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${widget.product.price.toStringAsFixed(2)}',
                            style: GoogleFonts.quicksand(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              Text(
                                '${widget.product.rating["rate"]}',
                                style: GoogleFonts.quicksand(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              //  Add to cart button
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5.0),
                child: ((widget.cart.firstWhere(
                            (element) =>
                                element['id'].toString() ==
                                widget.product.id.toString(),
                            orElse: () => null)) !=
                        null)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              removeFromCart(widget.product);
                            },
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                    color: const Color(0xffE80011),
                                    borderRadius: BorderRadius.circular(8)),
                                child: const Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                )),
                          ),
                          Text(countItemsInCart().toString(), style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 16),),
                          GestureDetector(
                            onTap: () {
                              addToCart(widget.product);
                            },
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                    color: const Color(0xffE80011),
                                    borderRadius: BorderRadius.circular(8)),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                )),
                          ),
                        ],
                      )
                    : FilledButton(
                        onPressed: () {
                          addToCart(widget.product);
                        },
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_shopping_cart_rounded),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Add to cart",
                              style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        )),
              )
            ],
          )),
    );
  }
}
