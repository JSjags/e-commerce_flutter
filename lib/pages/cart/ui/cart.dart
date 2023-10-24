import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/components/my_error_page.dart';
import 'package:e_commerce/data/theme.dart';
import 'package:e_commerce/pages/cart/bloc/cart_bloc.dart';
import 'package:e_commerce/pages/payment_success/ui/payment_success.dart';
import 'package:e_commerce/pages/profile/ui/profile.dart';
import 'package:e_commerce/pages/wishlist/bloc/wishlist_bloc.dart';
import 'package:e_commerce/services/user.dart' as user_actions;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_paystack/flutter_paystack.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  CartBloc cartBloc = CartBloc();

  List formatCart(List arr) {
    List temp = [];
    Map memo = {};

    for (var item in arr) {
      if (memo[item['id']] != null) {
        temp[memo[item['id']]]['count']++;
      } else {
        // add item to list
        temp.add({'item': item, 'count': 1});
        // update memo with item id and index
        memo[item['id']] =
            temp.indexWhere((element) => element['item']['id'] == item['id']);
      }
    }
    print(arr);
    print(memo);

    return temp;
  }

  double sumTotal(arr) {
    double sum = 0;
    for (var item in arr) {
      sum += item['count'] * item['item']['price'];
    }
    return sum;
  }

  double vat(arr) {
    double sum = 0;
    for (var item in arr) {
      sum += item['count'] * item['item']['price'];
    }
    return sum / 50;
  }

  void handleCheckout(BuildContext context, List filteredCart) async {
    final userAddress = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if (userAddress.data()?['address'] == null ||
        userAddress.data()?['address']['country'] == '' ||
        userAddress.data()?['address']['state'] == '' ||
        userAddress.data()?['address']['address1'] == '') {
      cartBloc.emit(AddressNotFoundState());
    } else {
      makePayment(filteredCart);
    }
  }

  // Setup paystack
  String publicKey = 'pk_test_1c476d17d8d46bacfe166a67414d13359fc4391b';
  final plugin = PaystackPlugin();
  String message = '';

  @override
  void initState() {
    super.initState();
    plugin.initialize(publicKey: publicKey);
  }

  void makePayment(List arr) async {
    double price = (sumTotal(arr) + vat(arr)) * 100 * 764;
    Charge charge = Charge()
      ..amount = price.toInt()
      ..reference = 'ref ${DateTime.now()}'
      ..email = FirebaseAuth.instance.currentUser!.email
      ..currency = 'NGN';

    CheckoutResponse response = await plugin.checkout(context,
        method: CheckoutMethod.card, charge: charge);

    if(response.status == true) {
        message = "Payment was successful. Ref: ${response.reference}";
        await user_actions.User.createOrder(uid: FirebaseAuth.instance.currentUser!.uid, items: arr);
        if(mounted) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => PaymentSuccess(message: message)), ModalRoute.withName('/'));
        }
    } else {
      if(mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          response.message,
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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: cartBloc,
      listenWhen: (previous, current) => current is CartActionState,
      buildWhen: (previous, current) => current is! CartActionState,
      listener: (context, state) {
        if (state is AddressNotFoundState) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  title: Text(
                    "Update Address",
                    style: GoogleFonts.quicksand(
                        color: const Color(0xff4F0000),
                        fontWeight: FontWeight.bold),
                  ),
                  content: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.add_location,
                        size: 40, color: Color(0xffE80011)),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Your address details seem to be incomplete or out of date, please update your address details so you can proceed to checkout.",
                      style: GoogleFonts.quicksand(),
                    ),
                  ]),
                  actionsPadding: EdgeInsets.all(20),
                  actions: [
                    OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(vertical: 12)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32))))),
                    FilledButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Profile()));
                        },
                        child: const Text("Update Address"))
                  ],
                );
              });
        }
      },
      builder: (context, state) {
        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done ||
                  snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  List cart = snapshot.data!['cart'];
                  List filteredCart = formatCart(cart);

                  if (filteredCart.isNotEmpty) {
                    return Column(
                      children: [
                        // cart items
                        Expanded(
                          child: ListView.builder(
                              itemCount: filteredCart.length,
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 20),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Image.network(
                                            filteredCart[index]['item']
                                                ['image'],
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
                                                    '${filteredCart[index]['item']['title']}',
                                                    style:
                                                        GoogleFonts.quicksand(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.star,
                                                            color: Colors.amber,
                                                          ),
                                                          Text(
                                                            '${filteredCart[index]['item']['rating']["rate"]}',
                                                            style: GoogleFonts
                                                                .quicksand(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            'Quantity: ${filteredCart[index]['count']}',
                                                            style: GoogleFonts
                                                                .quicksand(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                        Text(
                                                          '\$${filteredCart[index]['item']['price'].toStringAsFixed(2)}',
                                                          style: GoogleFonts
                                                              .quicksand(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        ),
                                                      ]),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  const Divider(
                                                    height: 1,
                                                    thickness: 1,
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text('Sub-total: ',
                                                            style: GoogleFonts
                                                                .quicksand(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                        Text(
                                                          '\$${(filteredCart[index]['item']['price'] * filteredCart[index]['count']).toStringAsFixed(2)}',
                                                          style: GoogleFonts
                                                              .quicksand(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ]),
                                                ],
                                              ),
                                            ),
                                          )
                                        ]),
                                  ),
                                );
                              }),
                        ),
                        Container(
                            color: const Color(0xffE80011),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Column(children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Total: ',
                                        style: GoogleFonts.quicksand(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                    Text(
                                      '\$${sumTotal(filteredCart).toStringAsFixed(2)}',
                                      style: GoogleFonts.quicksand(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ]),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('+ VAT: ',
                                        style: GoogleFonts.quicksand(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                    Text(
                                      '\$${vat(filteredCart).toStringAsFixed(2)}',
                                      style: GoogleFonts.quicksand(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ]),
                              const SizedBox(
                                height: 5,
                              ),
                              const Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: Colors.white54),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Bill',
                                        style: GoogleFonts.quicksand(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                    Text(
                                      '\$${(sumTotal(filteredCart) + vat(filteredCart)).toStringAsFixed(2)}',
                                      style: GoogleFonts.quicksand(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ]),
                              const SizedBox(
                                height: 5,
                              ),
                              FilledButton(
                                  onPressed: () =>
                                      handleCheckout(context, filteredCart),
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white)),
                                  child: Row(children: [
                                    const Icon(
                                      Icons.shopping_cart_checkout_rounded,
                                      color: Color(0xff4F0000),
                                    ),
                                    Expanded(
                                      child: Container(
                                        color: Colors.white,
                                        child: Center(
                                          child: Text("Proceed to checkout",
                                              style: GoogleFonts.quicksand(
                                                  color:
                                                      const Color(0xff4F0000),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                    )
                                  ])),
                            ]))
                      ],
                    );
                  } else {
                    return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.remove_shopping_cart_outlined,
                              size: 80,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              "Your shopping cart is empty, come back after adding items to your cart.",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.quicksand(
                                  fontSize: 16, color: Colors.grey),
                            )
                          ],
                        ));
                  }
                } else if (snapshot.hasError) {
                  return const ErrorPage(
                      message:
                          "We encountered an error, please check your network and refresh!");
                } else {
                  return const ErrorPage(
                      message:
                          "We encountered an error, please check your network and refresh!");
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.all(10.0),
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
                        "Connection lost! Please check your network and try again.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                            fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 15.0),
                      FilledButton(
                          onPressed: () {},
                          child: Text(
                            "Reconnect",
                            style: GoogleFonts.quicksand(),
                          ))
                    ],
                  ),
                ));
              }
            });
      },
    );
  }
}
