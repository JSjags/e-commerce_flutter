part of 'wishlist_bloc.dart';

@immutable
abstract class WishlistState {}

abstract class WishlistActionState extends WishlistState {}

class WishlistInitial extends WishlistState {}

class NavigateToProductDetailsState extends WishlistActionState {
  final String category;
  final int productIndex;

  NavigateToProductDetailsState({
    required this.category,
    required this.productIndex
  });
}