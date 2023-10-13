part of 'signup_bloc.dart';

@immutable
abstract class SignupState {}

abstract class SignupActionState extends SignupState {}

class SignupInitial extends SignupState {}

class UserSignupFailedState extends SignupState {}

class UserSigningUpState extends SignupState {}

class LoginNavigateToSignupActionState extends SignupActionState {}