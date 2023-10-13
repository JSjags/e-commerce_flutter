import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonClickedEvent>(loginButtonClickedEvent);
    on<SignupButtonNavigateEvent>(signupButtonNavigateEvent);
    on<OAuthButtonClickedEvent>(oAuthButtonClickedEvent);
  }

  FutureOr<void> loginButtonClickedEvent(LoginButtonClickedEvent event, Emitter<LoginState> emit) {
    emit(UserLoggingInState());
  }

  FutureOr<void> signupButtonNavigateEvent(SignupButtonNavigateEvent event, Emitter<LoginState> emit) {
    emit(NavigateToSignupState());
  }

  FutureOr<void> oAuthButtonClickedEvent(OAuthButtonClickedEvent event, Emitter<LoginState> emit) {
  emit(UserLoggingInState());
  }
}
