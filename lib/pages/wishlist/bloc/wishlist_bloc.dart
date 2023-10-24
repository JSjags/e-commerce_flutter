import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc() : super(WishlistInitial()) {
    on<ShopItemTileClickedEvent>(shopItemTileClickedEvent);
  }
}

FutureOr<void> shopItemTileClickedEvent(ShopItemTileClickedEvent event, Emitter<WishlistState> emit) {
  emit(NavigateToProductDetailsState(category: event.category, productIndex: event.productIndex));
}
