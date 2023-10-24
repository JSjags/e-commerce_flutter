part of 'shop_bloc.dart';

@immutable
abstract class ShopState {}

abstract class ShopActionState extends ShopState {}

class ShopInitial extends ShopState {}

class ShopInitialLoadingState extends ShopState {}

class ShopLoadedSuccessState extends ShopState {
  final List<Product> products;
  final List<String> categories;

  ShopLoadedSuccessState({
    required this.products,
    required this.categories
});
}

class NavigateToProductDetailsState extends ShopActionState {
  final String category;
  final int productIndex;

  NavigateToProductDetailsState({
    required this.category,
    required this.productIndex
  });
}

class NavigateToCategoryState extends ShopActionState {
  final String category;

  NavigateToCategoryState({
    required this.category,
  });
}
