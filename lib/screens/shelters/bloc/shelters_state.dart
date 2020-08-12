part of 'shelters_bloc.dart';

abstract class SheltersState extends Equatable {
  const SheltersState();
  @override
  List<Object> get props => [];
}

class SheltersInitial extends SheltersState {}

class ShelOpenModalBottomSheetState extends SheltersState {}

class ShelCloseModalBottomSheetState extends SheltersState {}

class ShelAddNewShelterLoadingState extends SheltersState {}

class ShelAddNewShelterErrorState extends SheltersState {
  final String message;

  ShelAddNewShelterErrorState(this.message);
}

class ShelAddNewShelterSuccessState extends SheltersState {}

class ShelSearchSheltersLoadingState extends SheltersState {}

class ShelSearchSheltersErrorState extends SheltersState {
  final String message;

  ShelSearchSheltersErrorState(this.message);
}

class ShelSearchSheltersSuccessState extends SheltersState {
  final List<Shelter> shelters;

  ShelSearchSheltersSuccessState({@required this.shelters});
}

class ShelSelectAddressState extends SheltersState {
  final AddressSearchItem addressSearchItem;

  ShelSelectAddressState(this.addressSearchItem);
  @override
  List<Object> get props => [addressSearchItem];
}

class ShelSelectAddressChangeLocationState extends SheltersState {
  // Это свойство только для того, чтобы equatable видел разные стэйты.
  // Фактически, оно нигде не используется.
  final String address;

  ShelSelectAddressChangeLocationState(this.address);
  @override
  List<Object> get props => [address];
  // final AddressSearchItem addressSearchItem;

  // ShelSelectAddressChangeLocationState(this.addressSearchItem);
}

class ShelPickPhotoForAddingShelterState extends SheltersState {
  final String imageName;

  ShelPickPhotoForAddingShelterState(this.imageName);
  @override
  List<Object> get props => [imageName];
}
