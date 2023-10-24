import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'payment_success_event.dart';
part 'payment_success_state.dart';

class PaymentSuccessBloc extends Bloc<PaymentSuccessEvent, PaymentSuccessState> {
  PaymentSuccessBloc() : super(PaymentSuccessInitial()) {
    on<PaymentSuccessEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
