import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/components/my_error_page.dart';
import 'package:e_commerce/components/my_shop_item_tile.dart';
import 'package:e_commerce/components/my_textfield.dart';
import 'package:e_commerce/models/Product.dart';
import 'package:e_commerce/pages/product_details/ui/product_details.dart';
import 'package:e_commerce/pages/search/bloc/search_bloc.dart';
import 'package:e_commerce/utils/search_debouncer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  SearchBloc searchBloc = SearchBloc();
  TextEditingController searchController = TextEditingController();
  final debouncer = Debouncer(milliseconds: 1000);

  List<Product> queriedProducts = [];

  Future handleSearch(String value) async {
        print(value);
    try {
      if (value.trim().isNotEmpty) {
        debouncer.run(() async {
          try {
            searchBloc.emit(QueryingDataState());
            await queryProducts(value);
            searchBloc
                .emit(QueryingDataSuccessState(products: queriedProducts));
          } catch (e) {
            searchBloc.emit(QueryingDataErrorState());
          }
        }, value);
      } else {
        setState(() {
        queriedProducts = [];
        });
        debouncer.destroy();
        searchBloc
            .emit(QueryingDataSuccessState(products: queriedProducts));
      }
    } catch (e) {
      searchBloc.emit(QueryingDataErrorState());
    }
  }

  Future queryProducts(String query) async {
    try {
      var response = await http.get(Uri.https('fakestoreapi.com', '/products'));
      final List jsonData = jsonDecode(response.body);

      List filteredData = jsonData.where((element) => element['title'].toString().toLowerCase().contains(query.toLowerCase())).toList();

      if(filteredData.isNotEmpty) {
          for (var product in filteredData) {
            final formattedProduct = Product(
                id: product['id'],
                title: product['title'],
                description: product['description'],
                price: product['price'],
                rating: product['rating'],
                category: product['category'],
                image: product['image']);

            setState(() {
              queriedProducts.add(formattedProduct);
            });
          }
      } else {
        setState(() {
          queriedProducts = [];
        });
      }
      // for (var product in jsonData) {
      //   final formattedProduct = Product(
      //       id: product['id'],
      //       title: product['title'],
      //       description: product['description'],
      //       price: product['price'],
      //       rating: product['rating'],
      //       category: product['category'],
      //       image: product['image']);
      //
      //   if (product['title']
      //       .toString()
      //       .toLowerCase()
      //       .contains(query.toLowerCase())) {
      //
      //   } else {
      //     setState(() {
      //       queriedProducts.add(formattedProduct);
      //     });
      //   }
      // }
    } catch (e) {
      print(e);
    }
  }

  final _stream = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchBloc, SearchState>(
        bloc: searchBloc,
        listenWhen: (previous, current) => current is SearchActionState,
        listener: (context, state) {
          if (state is NavigateToCategoryProductDetailsState) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductDetails(
                        category: state.category,
                        productIndex: state.productIndex)));
          }
        },
        buildWhen: (previous, current) => current is! SearchActionState,
        builder: (context, state) {
          return StreamBuilder(
              stream: _stream,
              builder: (context, snapshot) {
                final List cart = snapshot.data?['cart'] ?? [];

                if (state is QueryingDataState) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      MyTextField(
                        controller: searchController,
                        hintText: "Search for products...",
                        obscureText: false,
                        prefixIcon: Icons.search_rounded,
                        padSides: true,
                        paddingValue: 15,
                        handleSearch: handleSearch,
                        isSearchPage: true,
                      ),
                      const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ],
                  );
                } else if (state is QueryingDataSuccessState) {
                  if(state.products.isNotEmpty) {
                    return ListView(
                      shrinkWrap: true,
                      children: [
                        MyTextField(
                          controller: searchController,
                          hintText: "Search for products...",
                          obscureText: false,
                          prefixIcon: Icons.search_rounded,
                          padSides: true,
                          paddingValue: 10,
                          handleSearch: handleSearch,
                          isSearchPage: true,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: queriedProducts.length,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.75),
                            itemBuilder: (context, index) {
                              return ShopItemTile(
                                product: queriedProducts[index],
                                currentBloc: searchBloc,
                                cart: cart,
                                context: context,
                              );
                            })
                      ],
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        MyTextField(
                          controller: searchController,
                          hintText: "Search for product...",
                          obscureText: false,
                          prefixIcon: Icons.search_rounded,
                          padSides: true,
                          paddingValue: 15,
                          handleSearch: handleSearch,
                          isSearchPage: true,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.grid_view_rounded,
                                size: 80,
                                color: Colors.grey,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  "Enter product name in the search box above to get results.",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.quicksand(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                } else if (state is QueryingDataErrorState) {
                  return const ErrorPage(
                      message:
                          "Could not search for your products due to an error, please try again some other time");
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      MyTextField(
                        controller: searchController,
                        hintText: "Search for products...",
                        obscureText: false,
                        prefixIcon: Icons.search_rounded,
                        padSides: true,
                        paddingValue: 15,
                        handleSearch: handleSearch,
                        isSearchPage: true,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.grid_view_rounded,
                              size: 80,
                              color: Colors.grey,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "Enter product name in the search box above to get results.",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.quicksand(
                                    fontSize: 16, color: Colors.grey),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                }
              });
        });
  }
}
