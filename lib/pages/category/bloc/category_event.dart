part of 'category_bloc.dart';

@immutable
abstract class CategoryEvent {}

class InitCategoryProductsLoadingEvent extends CategoryEvent {
  final String category;

  InitCategoryProductsLoadingEvent({
    required this.category
});
}

class CategoryItemTileClickedEvent extends CategoryEvent {
  final String category;
  final int productIndex;

  CategoryItemTileClickedEvent({
    required this.category,
    required this.productIndex
  });
}