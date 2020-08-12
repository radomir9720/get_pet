part of 'search_address_bloc.dart';

abstract class SearchAddressState extends Equatable {
  const SearchAddressState();
  @override
  List<Object> get props => [];
}

class SearchAddressInitial extends SearchAddressState {
  // @override
  // List<Object> get props => [];
}

class SearSearchAddressLoadingState extends SearchAddressState {}

class SearSearchAddressErrorState extends SearchAddressState {
  final String message;

  SearSearchAddressErrorState(this.message);
}

class SearSearchAddressResultState extends SearchAddressState {
  final List<AddressSearchItem> items;

  SearSearchAddressResultState({@required this.items});
}
