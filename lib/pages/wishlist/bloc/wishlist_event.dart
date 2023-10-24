part of 'wishlist_bloc.dart';

@immutable
abstract class WishlistEvent {}

class ShopItemTileClickedEvent extends WishlistEvent {
  final String category;
  final int productIndex;

  ShopItemTileClickedEvent({
    required this.category,
    required this.productIndex
  });
}