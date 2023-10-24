part of 'shop_bloc.dart';

@immutable
abstract class ShopEvent {}

class InitShopLoadingEvent extends ShopEvent {}

class ShopItemTileClickedEvent extends ShopEvent {
  final String category;
  final int productIndex;

  ShopItemTileClickedEvent({
    required this.category,
    required this.productIndex
});
}

class CategoryButtonClickedEvent extends ShopEvent {
  final String category;

  CategoryButtonClickedEvent({
    required this.category
});
}