import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/components/my_bestselling_tile.dart';
import 'package:e_commerce/components/my_category_tile.dart';
import 'package:e_commerce/components/my_hero_carousel.dart';
import 'package:e_commerce/components/my_shop_item_tile.dart';
import 'package:e_commerce/components/my_sub_header.dart';
import 'package:e_commerce/pages/category/ui/category.dart';
import 'package:e_commerce/pages/product_details/ui/product_details.dart';
import 'package:e_commerce/pages/shop/bloc/shop_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  ShopBloc shopBloc = ShopBloc();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shopBloc.add(InitShopLoadingEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopBloc, ShopState>(
      bloc: shopBloc,
      listenWhen: (previous, current) => current is ShopActionState,
      buildWhen: (previous, current) => current is! ShopActionState,
      listener: (context, state) {
        if(state is NavigateToProductDetailsState) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetails(category: state.category, productIndex: state.productIndex)));
        }
        if(state is NavigateToCategoryState) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Category(category: state.category)));
        }
      },
      builder: (context, state) {
        if (state is ShopInitialLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ShopLoadedSuccessState) {
          final successState = state;
          final firstHalf = successState.products.sublist(0, 10).toList();
          final secondHalf = successState.products.sublist(10, 20).toList();
          final bestSellingProducts = [
            successState.products[4],
            successState.products[9],
            successState.products[19],
            successState.products[15],
            successState.products[6]
          ];
          return StreamBuilder(stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(), builder: (context, snapshot) {
            final List cart = snapshot.data?['cart']??[];

            return ListView(
              shrinkWrap: true,
              children: [
                const HeroCarousel(),
                const SizedBox(height: 20.0),
                //  Best-selling items
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SubHeader(content: "Best-Selling Products"),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 200,
                        child: ListView.builder(
                          shrinkWrap: true,
                          clipBehavior: Clip.none,
                          scrollDirection: Axis.horizontal,
                          itemCount: bestSellingProducts.length,
                          itemBuilder: (context, index) {
                            return BestSellingTile(
                                product: bestSellingProducts[index], shopBloc: shopBloc);
                          },
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 40.0),
                //  Shop items first section
                Container(
                  padding: const EdgeInsets.all(10),
                  child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: firstHalf.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.75),
                      itemBuilder: (context, index) {
                        return ShopItemTile(product: firstHalf[index], currentBloc: shopBloc, cart: cart, context: context,);
                      }),
                ),
                const SizedBox(height: 10.0,),
                //  Categories
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SubHeader(content: "Categories"),
                      const SizedBox(height: 10.0,),
                      Container(
                        height: 50,
                        child: ListView.builder(
                            shrinkWrap: true,
                            clipBehavior: Clip.none,
                            scrollDirection: Axis.horizontal,
                            itemCount: successState.categories.length,
                            itemBuilder: (context, index) {
                              return CategoryTile(
                                category: successState.categories[index], shopBloc: shopBloc,);
                            }),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20.0,),
                //  Shop items second section
                Container(
                  padding: const EdgeInsets.all(10),
                  child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: secondHalf.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.75),
                      itemBuilder: (context, index) {
                        return ShopItemTile(product: secondHalf[index], currentBloc: shopBloc, cart: cart, context: context,);
                      }),
                ),
                const SizedBox(height: 60.0,)
              ],
            );
          });
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
