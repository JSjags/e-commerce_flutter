part of 'search_bloc.dart';

@immutable
abstract class SearchState {}

abstract class SearchActionState extends SearchState {}

class SearchInitial extends SearchState {}

class QueryingDataState extends SearchState {}

class QueryingDataSuccessState extends SearchState {
  final List<Product> products;

  QueryingDataSuccessState({
    required this.products
});
}

class QueryingDataErrorState extends SearchState {}

class NavigateToCategoryProductDetailsState extends SearchActionState {
  final String category;
  final int productIndex;

  NavigateToCategoryProductDetailsState({
    required this.category,
    required this.productIndex
  });
}
