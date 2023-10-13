part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent {}

class SignupButtonClickedEvent extends SignupEvent {

}

class OAuthButtonClickedEvent extends SignupEvent {

}

class LoginButtonNavigateEvent extends SignupEvent {

}


