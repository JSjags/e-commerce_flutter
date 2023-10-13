part of 'forgot_password_bloc.dart';

@immutable
abstract class ForgotPasswordState {}

abstract class ForgotPasswordActionState extends ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ResetPasswordButtonClickedState extends ForgotPasswordState {}

class ResetPasswordFailedState extends ForgotPasswordState {}

class PasswordResetSuccessfulState extends ForgotPasswordState {}

class BackToLoginClickedState extends ForgotPasswordActionState {}
