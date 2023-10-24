part of 'product_details_bloc.dart';

@immutable
abstract class ProductDetailsState {}

abstract class ProductDetailsActionState extends ProductDetailsState {}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsLoadingState extends ProductDetailsState {}

class ProductDetailsLoadedSuccessState extends ProductDetailsState {
  final Product product;
  final List wishlist;

  ProductDetailsLoadedSuccessState({
    required this.product,
    required this.wishlist
});

}
