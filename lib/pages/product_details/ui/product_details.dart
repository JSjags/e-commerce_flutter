import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/components/my_sub_header.dart';
import 'package:e_commerce/data/theme.dart';
import 'package:e_commerce/models/Product.dart';
import 'package:e_commerce/pages/home/ui/home.dart';
import 'package:e_commerce/pages/product_details/bloc/product_details_bloc.dart';
import 'package:e_commerce/pages/shop/ui/shop.dart';
import 'package:e_commerce/pages/wishlist/ui/wishlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:badges/badges.dart' as badges;

class ProductDetails extends StatefulWidget {
  final String category;
  final int productIndex;

  const ProductDetails(
      {super.key, required this.category, required this.productIndex});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  ProductDetailsBloc productDetailsBloc = ProductDetailsBloc();

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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
              onPressed: ScaffoldMessenger.of(context).removeCurrentSnackBar,
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

  Future removeFromCart(Product product, BuildContext context) async {
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
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                onPressed: ScaffoldMessenger.of(context).removeCurrentSnackBar,
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
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                onPressed: ScaffoldMessenger.of(context).removeCurrentSnackBar,
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

  String countItemsInCart(List cart) {
    List filter = [];
    filter.addAll(cart);

    filter.retainWhere((element) =>
        element['id'].toString() == widget.productIndex.toString());

    return filter.length.toString();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productDetailsBloc.add(GetProductDetailsEvent(
        category: widget.category, productIndex: widget.productIndex));
  }

  final _stream = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductDetailsBloc, ProductDetailsState>(
        bloc: productDetailsBloc,
        listenWhen: (previous, current) => current is ProductDetailsActionState,
        buildWhen: (previous, current) => current is! ProductDetailsActionState,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ProductDetailsLoadingState) {
            return Scaffold(
                backgroundColor: Colors.grey.shade200,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Color(0xff4F0000),
                      )),
                  centerTitle: true,
                  title: Text(
                    "Product Details",
                    style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff4F0000)),
                  ),
                ),
                body: const Center(child: CircularProgressIndicator()));
          } else if (state is ProductDetailsLoadedSuccessState) {
            // wishlist functionality
            Future<bool> onLikeButtonTapped(bool isLiked) async {
              final users = FirebaseFirestore.instance.collection('users');
              final docRef = users.doc(FirebaseAuth.instance.currentUser!.uid);

              /// send your request here
              // final bool success= await sendRequest();
              await docRef.get().then((DocumentSnapshot doc) {
                if (doc.exists) {
                  final copiedData = doc.data() as Map<String, dynamic>;
                  final List wishlist = copiedData['wishlist'];

                  // Remove from wishlist
                  if ((wishlist.firstWhere(
                          (element) =>
                              element['id'].toString() ==
                              state.product.id.toString(),
                          orElse: () => null)) !=
                      null) {
                    final itemToRemove = wishlist.firstWhere(
                        (element) =>
                            element['id'].toString() ==
                            state.product.id.toString(),
                        orElse: () => null);

                    print('item to remove $itemToRemove');
                    wishlist.remove(itemToRemove);
                    docRef.update({'wishlist': wishlist}).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "Item removed from wishlist",
                          style: GoogleFonts.quicksand(color: Colors.black54),
                        ),
                        padding: const EdgeInsets.only(left: 20),
                        backgroundColor: Colors.orange,
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
                      ));
                      return true;
                    });
                  } else {
                    // Add to wishlist
                    docRef.update({
                      'wishlist':
                          FieldValue.arrayUnion([state.product.toJson()])
                    }).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "Item added to wishlist",
                          style: GoogleFonts.quicksand(color: Colors.black54),
                        ),
                        padding: const EdgeInsets.only(left: 20),
                        backgroundColor: Colors.cyan,
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
                      ));
                      return true;
                    });
                  }
                } else {
                  print("User data already exists");
                }
              }, onError: (e) => throw e);

              /// if failed, you can do nothing
              // return success? !isLiked:isLiked;

              return !isLiked;
            }
            return StreamBuilder(
                stream: _stream,
                builder: (context, snapshot) {
                  final List cart = snapshot.data?['cart'] ?? [];
                  final List wishlist = snapshot.data?['wishlist'] ?? [];

                  return Scaffold(
                      backgroundColor: Colors.grey.shade200,
                      appBar: AppBar(
                        backgroundColor: Colors.white,
                        elevation: 5,
                        leading: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back_ios_rounded,
                              color: Color(0xff4F0000),
                            )),
                        centerTitle: true,
                        title: Text(
                          "Product Details",
                          style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff4F0000)),
                        ),
                        actions: [
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                print("Tapped");
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const Home(page: 3,)));
                              },
                              child: badges.Badge(
                                position: badges.BadgePosition.topEnd(top: -10, end: -12),
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
                                child: const Icon(Icons.shopping_cart_outlined, color: Color(0xff4F0000),),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10,)
                        ],
                      ),
                      bottomNavigationBar: Container(
                        padding: const EdgeInsets.all(10),
                        height: 70,
                        child: Row(children: [
                          // Back to home/shop
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xffE80011),
                                    width: 1,
                                  )),
                              child: const Center(
                                  child: Icon(
                                Icons.store_mall_directory_rounded,
                                color: Color(0xffE80011),
                              )),
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          // Go to wishlist
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const Home(page: 1)));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xffE80011),
                                    width: 1,
                                  )),
                              child: const Center(
                                  child: Icon(
                                Icons.favorite_outline_rounded,
                                color: Color(0xffE80011),
                              )),
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                              child: ((cart.firstWhere(
                                      (element) =>
                                  element['id'].toString() ==
                                      widget.productIndex.toString(),
                                  orElse: () => null)) !=
                                  null)
                                  ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      removeFromCart(state.product, context);
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 14),
                                        decoration: BoxDecoration(
                                            color: const Color(0xffE80011),
                                            borderRadius: BorderRadius.circular(8)),
                                        child: const Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                        )),
                                  ),
                                  Text(countItemsInCart(cart).toString(), style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 16),),
                                  GestureDetector(
                                    onTap: () {
                                      addToCart(state.product);
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 14),
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
                                  : GestureDetector(
                                  onTap: () {
                                    addToCart(state.product);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
                                    decoration: BoxDecoration(color: const Color(0xffE80011), borderRadius: BorderRadius.circular(8)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.add_shopping_cart_rounded, color: Colors.white,),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              "Add to cart",
                                              style: GoogleFonts.quicksand(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white, fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  )),),
                        ]),
                      ),
                      body: ListView(
                        children: [
                          // Image
                          Container(
                            padding: const EdgeInsets.all(20),
                            width: double.maxFinite,
                            color: Colors.white,
                            child: Image.network(
                              state.product.image,
                              height: 400,
                            ),
                          ),
                          //  Details
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.product.title,
                                  style: GoogleFonts.quicksand(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xff4F0000),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Category: ${state.product.category}',
                                  style: GoogleFonts.quicksand(),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '\$${state.product.price.toStringAsFixed(2)}',
                                  style: GoogleFonts.quicksand(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Ratings
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          state.product.rating['rate']
                                              .toString(),
                                          style: GoogleFonts.quicksand(),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '(${state.product.rating['count'].toString()} ${state.product.rating['count'] > 1 ? 'ratings)' : 'rating)'}',
                                          style: GoogleFonts.quicksand(
                                              color: const Color(0xffE80011)),
                                        )
                                      ],
                                    ),
                                    LikeButton(
                                      onTap: onLikeButtonTapped,
                                      size: 24.0,
                                      isLiked: (wishlist.firstWhere(
                                              (element) =>
                                                  element['id'].toString() ==
                                                  state.product.id.toString(),
                                              orElse: () => null)) !=
                                          null,
                                      circleColor: const CircleColor(
                                          start: Color(0xff00ddff),
                                          end: Color(0xff0099cc)),
                                      bubblesColor: const BubblesColor(
                                        dotPrimaryColor: Colors.yellow,
                                        dotSecondaryColor: Colors.cyan,
                                      ),
                                      likeBuilder: (bool isLiked) {
                                        return Icon(
                                          isLiked
                                              ? Icons.favorite
                                              : Icons.favorite_outline_rounded,
                                          color: isLiked
                                              ? const Color(0xffE80011)
                                              : Colors.grey,
                                          size: 24.0,
                                        );
                                      },
                                    ),
                                  ],
                                  // color: Color(0xffE80011),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const SubHeader(content: "Description"),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Category: ${state.product.description}',
                                  style: GoogleFonts.quicksand(),
                                ),
                                const SizedBox(
                                  height: 20,
                                )
                              ],
                            ),
                          )
                        ],
                      ));
                });
          } else {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Color(0xff4F0000),
                    )),
                centerTitle: true,
                title: Text(
                  "Product Details",
                  style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff4F0000)),
                ),
              ),
              body: const SizedBox(),
            );
          }
        });
  }
}
