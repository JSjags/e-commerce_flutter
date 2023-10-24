import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:e_commerce/models/Product.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchItemTileClickedEvent>(categoryItemTileClickedEvent);
  }

  FutureOr<void> categoryItemTileClickedEvent(SearchItemTileClickedEvent event, Emitter<SearchState> emit) {
    emit(NavigateToCategoryProductDetailsState(category: event.category, productIndex: event.productIndex));
  }
}
