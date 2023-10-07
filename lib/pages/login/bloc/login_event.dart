part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginButtonClickedEvent extends LoginEvent {

}

class SignupButtonNavigateEvent extends LoginEvent {

}

class ForgotPasswordButtonClickedEvent extends LoginEvent {

}
