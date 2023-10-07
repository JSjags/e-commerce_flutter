part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

abstract class LoginActionState extends LoginState {}

class LoginInitial extends LoginState {}

class UserLoggingInState extends LoginState {}

class UserLoginFailedState extends LoginState {}

class NavigateToSignupState extends LoginActionState {}

class NavigateToForgotPasswordState extends LoginActionState {}
