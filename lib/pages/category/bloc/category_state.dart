part of 'category_bloc.dart';

@immutable
abstract class CategoryState {}

abstract class CategoryActionState extends CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryProductsLoadingState extends CategoryState {}

class CategoryProductsLoadedSuccessState extends CategoryState {
  final List<Product> products;
  // final List<String> categories;

  CategoryProductsLoadedSuccessState({
    required this.products,
    // required this.categories
  });
}

class NavigateToCategoryProductDetailsState extends CategoryActionState {
  final String category;
  final int productIndex;

  NavigateToCategoryProductDetailsState({
    required this.category,
    required this.productIndex
  });
}
