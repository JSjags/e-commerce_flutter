import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/components/my_shop_item_tile.dart';
import 'package:e_commerce/pages/category/bloc/category_bloc.dart';
import 'package:e_commerce/pages/product_details/ui/product_details.dart';
import 'package:e_commerce/pages/shop/bloc/shop_bloc.dart';
import 'package:e_commerce/utils/category_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class Category extends StatefulWidget {
  final String category;
  const Category({super.key, required this.category});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  CategoryBloc categoryBloc = CategoryBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categoryBloc
        .add(InitCategoryProductsLoadingEvent(category: widget.category));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryBloc, CategoryState>(
        bloc: categoryBloc,
        listenWhen: (previous, current) => current is CategoryActionState,
        buildWhen: (previous, current) => current is! CategoryActionState,
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
        builder: (context, state) {
          if (state is CategoryProductsLoadingState) {
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
                    CategoryUtils.generateCategoryText(widget.category),
                    style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff4F0000)),
                  ),
                ),
                body: const Center(child: CircularProgressIndicator()));
          } else if (state is CategoryProductsLoadedSuccessState) {
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  final List cart = snapshot.data?['cart'] ?? [];

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
                        CategoryUtils.generateCategoryText(widget.category),
                        style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff4F0000)),
                      ),
                    ),
                    body: ListView(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.products.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 0.75),
                              itemBuilder: (context, index) {
                                return ShopItemTile(
                                  product: state.products[index],
                                  currentBloc: categoryBloc,
                                  cart: cart,
                                  context: context,
                                );
                              }),
                        ),
                        const SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  );
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
                  CategoryUtils.generateCategoryText(widget.category),
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
