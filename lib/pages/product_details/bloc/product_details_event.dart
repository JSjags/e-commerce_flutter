part of 'product_details_bloc.dart';

@immutable
abstract class ProductDetailsEvent {}

class GetProductDetailsEvent extends ProductDetailsEvent {
  final String category;
  final int productIndex;

  GetProductDetailsEvent(
      {required this.category, required this.productIndex});
}