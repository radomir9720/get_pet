part of 'shelters_bloc.dart';

abstract class SheltersEvent extends Equatable {
  const SheltersEvent();

  @override
  List<Object> get props => [];
}

class ShelOpenModalBottomSheetEvent extends SheltersEvent {}

class ShelCloseModalBottomSheetEvent extends SheltersEvent {}

class ShelAddNewShelterEvent extends SheltersEvent {
  final Shelter shelter;

  ShelAddNewShelterEvent({
    @required this.shelter,
  });
}

class ShelSelectAddressEvent extends SheltersEvent {
  final AddressSearchItem addressSearchItem;

  ShelSelectAddressEvent(this.addressSearchItem);

  @override
  List<Object> get props => [addressSearchItem];
}

class ShelSelectAddressChangeLocationEvent extends SheltersEvent {
  final AddressSearchItem addressSearchItem;

  ShelSelectAddressChangeLocationEvent(this.addressSearchItem);

  @override
  List<Object> get props => [addressSearchItem];
}

class ShelSearchSheltersEvent extends SheltersEvent {}

class ShelPickPhotoForAddingShelterEvent extends SheltersEvent {}
