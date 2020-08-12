part of 'search_address_bloc.dart';

abstract class SearchAddressEvent extends Equatable {
  const SearchAddressEvent();
}

class SearSearchAddressEvent extends SearchAddressEvent {
  final String address;

  SearSearchAddressEvent(this.address);

  @override
  List<Object> get props => [address];
}
