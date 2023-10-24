import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:e_commerce/models/Product.dart';
import 'package:e_commerce/pages/shop/ui/shop.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'shop_event.dart';
part 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  ShopBloc() : super(ShopInitial()) {
    on<InitShopLoadingEvent>(initShopLoadingEvent);
    on<ShopItemTileClickedEvent>(shopItemTileClickedEvent);
    on<CategoryButtonClickedEvent>(categoryButtonClickedEvent);
  }

  FutureOr<void> initShopLoadingEvent(
      InitShopLoadingEvent event, Emitter<ShopState> emit) async {
    // Create empty list for products and categories
    List<Product> myProducts = [];
    List<String> categories = [];

    // Show loading indicator
    emit(ShopInitialLoadingState());

    //  Fetch products
    Future fetchProducts() async {
      try {
        var response = await http.get(Uri.https('fakestoreapi.com', '/products'));
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
    Future fetchCategories() async {
      try {
        var response = await http.get(Uri.https('fakestoreapi.com', '/products/categories'));
        var jsonData = jsonDecode(response.body);


        for (var product in jsonData) {
          categories.add(product);
        }
      } catch (e) {
        print(e);
      }

    }
    try {
      await fetchProducts();
      await fetchCategories();
      emit(ShopLoadedSuccessState(products: myProducts.toList(), categories: categories.toList()));
    } catch (e) {
      // print(e.toString);
    }
  }

  FutureOr<void> shopItemTileClickedEvent(ShopItemTileClickedEvent event, Emitter<ShopState> emit) {
    emit(NavigateToProductDetailsState(category: event.category, productIndex: event.productIndex));
  }

  FutureOr<void> categoryButtonClickedEvent(CategoryButtonClickedEvent event, Emitter<ShopState> emit) {
  emit(NavigateToCategoryState(category: event.category));
  }
}
