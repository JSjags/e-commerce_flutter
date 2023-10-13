import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<BackToLoginClickedEvent>(backToLoginClickedEvent);
    on<ResetPasswordFailedEvent>(resetPasswordFailedEvent);
    on<ResetPasswordButtonClickedEvent>(resetPasswordButtonClickedEvent);
    on<PasswordResetSuccessfulEvent>(passwordResetSuccessfulEvent);
  }

  FutureOr<void> backToLoginClickedEvent(BackToLoginClickedEvent event, Emitter<ForgotPasswordState> emit) {
    emit(BackToLoginClickedState());
  }

  FutureOr<void> resetPasswordFailedEvent(ResetPasswordFailedEvent event, Emitter<ForgotPasswordState> emit) {
    emit(ResetPasswordFailedState());
  }

  FutureOr<void> resetPasswordButtonClickedEvent(ResetPasswordButtonClickedEvent event, Emitter<ForgotPasswordState> emit) {
    emit(ResetPasswordButtonClickedState());
  }

  FutureOr<void> passwordResetSuccessfulEvent(PasswordResetSuccessfulEvent event, Emitter<ForgotPasswordState> emit) {
    emit(PasswordResetSuccessfulState());
  }
}
