import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:e_commerce/models/Product.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitial()) {
    on<InitCategoryProductsLoadingEvent>(initCategoryProductsLoadingEvent);
    on<CategoryItemTileClickedEvent>(categoryItemTileClickedEvent);
  }

  FutureOr<void> initCategoryProductsLoadingEvent(InitCategoryProductsLoadingEvent event, Emitter<CategoryState> emit) async {
    // Create empty list for products and categories
    List<Product> myProducts = [];
    // List<String> categories = [];

    // Show loading indicator
    emit(CategoryProductsLoadingState());

    //  Fetch products
    Future fetchProducts() async {
      try {
        var response = await http.get(Uri.https('fakestoreapi.com', '/products/category/${event.category}'));
        var jsonData = jsonDecode(response.body);

        for (var product in jsonData) {
          final formattedProduct = Product(
              id: product['id'],
              title: product['title'],
              description: product['description'],
              price: product['price'],
              rating: product['rating'],
              category: product['category'],
              image: product['image']);
          myProducts.add(formattedProduct);
        }
      } catch (e) {
        print(e);
      }

    }
    // Future fetchCategories() async {
    //   try {
    //     var response = await http.get(Uri.https('fakestoreapi.com', '/products/categories'));
    //     var jsonData = jsonDecode(response.body);
    //
    //
    //     for (var product in jsonData) {
    //       categories.add(product);
    //     }
    //   } catch (e) {
    //     print(e);
    //   }
    //
    // }
    try {
      await fetchProducts();
      // await fetchCategories();
      emit(CategoryProductsLoadedSuccessState(products: myProducts.toList()));
    } catch (e) {
      // print(e.toString);
    }
  }
}

FutureOr<void> categoryItemTileClickedEvent(CategoryItemTileClickedEvent event, Emitter<CategoryState> emit) {
  emit(NavigateToCategoryProductDetailsState(category: event.category, productIndex: event.productIndex));
}
