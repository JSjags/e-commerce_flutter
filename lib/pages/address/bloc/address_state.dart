part of 'address_bloc.dart';

@immutable
abstract class AddressState {}

abstract class AddressActionState extends AddressState {}

class AddressInitial extends AddressState {}

class SavingAddressInformation extends AddressState {}

class AddressSuccessfullyUpdatedState extends AddressActionState {}

class AddressUpdateErrorState extends AddressActionState {}