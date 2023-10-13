part of 'forgot_password_bloc.dart';

@immutable
abstract class ForgotPasswordEvent {}

class BackToLoginClickedEvent extends ForgotPasswordEvent {

}

class ResetPasswordFailedEvent extends ForgotPasswordEvent {

}

class PasswordResetSuccessfulEvent extends ForgotPasswordEvent {

}

class ResetPasswordButtonClickedEvent extends ForgotPasswordEvent {

}