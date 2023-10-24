part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class SearchItemTileClickedEvent extends SearchEvent {
  final String category;
  final int productIndex;

  SearchItemTileClickedEvent({
    required this.category,
    required this.productIndex
  });
}