import 'package:e_commerce/pages/category/bloc/category_bloc.dart';
import 'package:e_commerce/pages/shop/bloc/shop_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryTile extends StatelessWidget {
  final String category;
  final ShopBloc shopBloc;

  List figureIcon(String value) {
    IconData iconFigured;
    Color color;
    Color colorShade;

    switch(category) {
      case "electronics":
        iconFigured = Icons.memory_rounded;
        color = Colors.deepOrange;
        colorShade = Colors.deepOrange.shade100;
        break;
      case "jewelery":
        iconFigured = Icons.diamond_outlined;
        color = Colors.purple;
        colorShade = Colors.purple.shade100;
        break;
      case "men's clothing":
        iconFigured = Icons.male_rounded;
        color = Colors.teal;
        colorShade = Colors.teal.shade100;
        break;
      case "women's clothing":
        iconFigured = Icons.female_rounded;
        color = Colors.blue;
        colorShade = Colors.blue.shade100;
        break;
      default:
        iconFigured = Icons.shopping_basket_outlined;
        color = Colors.amber;
        colorShade = Colors.amber.shade100;
        break;
    }
    return [iconFigured, color, colorShade];
  }

  const CategoryTile({
    super.key,
    required this.category,
    required this.shopBloc
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => shopBloc.add(CategoryButtonClickedEvent(category: category)),
      child: Container(
        margin: const EdgeInsets.only(right: 10.0),
        padding: const EdgeInsets.only(left: 20, right: 30),
        decoration: BoxDecoration(color: figureIcon(category)[2], borderRadius: BorderRadius.circular(205)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(figureIcon(category)[0], color: figureIcon(category)[1], size: 40, ),
              const SizedBox(width: 10,),
              Text(category.toUpperCase(), style: GoogleFonts.quicksand(fontSize: 16, color: figureIcon(category)[1], fontWeight: FontWeight.w600, letterSpacing: 3,),)
            ],
        ),
      ),
    );
  }
}
