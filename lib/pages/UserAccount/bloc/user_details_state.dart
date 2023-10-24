part of 'user_details_bloc.dart';

@immutable
abstract class UserDetailsState {}

abstract class UserDetailsActionState extends UserDetailsState {}

class UserDetailsInitial extends UserDetailsState {}

class SavingUserInformation extends UserDetailsState {}

class UserDetailsSuccessfullyUpdatedState extends UserDetailsActionState {}

class UserDetailsUpdateErrorState extends UserDetailsActionState {}