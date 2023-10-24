import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitial()) {
    on<LoginButtonNavigateEvent>(loginButtonNavigateEvent);
    on<SignupButtonClickedEvent>(signupButtonClickedEvent);
    on<OAuthButtonClickedEvent>(oAuthButtonClickedEvent);
  }

  FutureOr<void> loginButtonNavigateEvent(LoginButtonNavigateEvent event, Emitter<SignupState> emit) {
    emit(LoginNavigateToSignupActionState());
  }

  FutureOr<void> signupButtonClickedEvent(SignupButtonClickedEvent event, Emitter<SignupState> emit) {
    emit(UserSigningUpState());
  }

  FutureOr<void> oAuthButtonClickedEvent(OAuthButtonClickedEvent event, Emitter<SignupState> emit) {
    emit(UserSigningUpState());
  }
}
