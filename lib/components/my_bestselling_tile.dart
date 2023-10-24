import 'package:e_commerce/models/Product.dart';
import 'package:e_commerce/pages/shop/bloc/shop_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BestSellingTile extends StatelessWidget {
  final Product product;
  final ShopBloc shopBloc;

  const BestSellingTile({super.key, required this.product, required this.shopBloc});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => shopBloc.add(ShopItemTileClickedEvent(category: product.category ,productIndex: product.id)),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.grey[200], boxShadow: const [
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
            ), //BoxShadow
          ]),
          width: 200,
          height: 160,
          margin: const EdgeInsets.only(right: 10.0),
          child: Column(
            children: [
              // Thumbnail
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                width: double.maxFinite,
                child: Image.network(
                  product.image,
                  fit: BoxFit.contain,
                  height: 100,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Text('${product.title}\n', style: GoogleFonts.quicksand(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis,),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('\$${product.price.toStringAsFixed(2)}', style: GoogleFonts.quicksand(fontSize: 20, fontWeight: FontWeight.bold),),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber,),
                            Text('${product.rating["rate"]}', style: GoogleFonts.quicksand(fontSize: 16, fontWeight: FontWeight.bold),),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
