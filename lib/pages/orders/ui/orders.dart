import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/components/my_error_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Orders extends StatelessWidget {
  const Orders({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
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
            "Orders",
            style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold, color: const Color(0xff4F0000)),
          ),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("orders")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done ||
                  snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  List filteredCart = snapshot.data!['orders'];

                  if (filteredCart.isNotEmpty) {
                    return ListView(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      children: [
                        for(var order in filteredCart)
                          // Order list
                          Column(
                            // Order-ID
                            children: [
                              const SizedBox(height: 20,),
                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
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
                                    ],),
                                child: Column(
                                  children: [const SizedBox(height: 10,),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Order-ID:', style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),),
                                          const SizedBox(height: 5,),
                                          Text(order['order_id'], style: GoogleFonts.quicksand(),),
                                        ],
                                      ),
                                    ),
                                    ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: order['order_items'].length,
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, bottom: 20),
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10),),
                                                child: Container(
                                                  margin: const EdgeInsets.only(top: 10),
                                                  padding: const EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(8)),
                                                  child: Row(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                      children: [
                                                        Image.network(
                                                          order['order_items'][index]['item']
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
                                                                  '${order['order_items'][index]['item']['title']}',
                                                                  style:
                                                                  GoogleFonts.quicksand(
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .bold),
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
                                                                          '${order['order_items'][index]['item']['rating']["rate"]}',
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
                                                                          'Quantity: ${order['order_items'][index]['count']}',
                                                                          style: GoogleFonts
                                                                              .quicksand(
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .w600)),
                                                                      Text(
                                                                        '\$${order['order_items'][index]['item']['price'].toStringAsFixed(2)}',
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
                                                                        '\$${(order['order_items'][index]['item']['price'] * order['order_items'][index]['count']).toStringAsFixed(2)}',
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
                                              ),
                                            ],
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 50,)
                        ]
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
            }));
  }
}
