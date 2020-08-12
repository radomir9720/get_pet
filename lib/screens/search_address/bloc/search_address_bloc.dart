import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_pet/global/bloc/app_bloc.dart';
import 'package:get_pet/global/models/address_search_item.dart';

part 'search_address_event.dart';
part 'search_address_state.dart';

class SearchAddressBloc extends Bloc<SearchAddressEvent, SearchAddressState> {
  final AppBloc _appBloc;

  SearchAddressBloc(this._appBloc);

  @override
  Stream<SearchAddressState> mapEventToState(
    SearchAddressEvent event,
  ) async* {
    if (event is SearSearchAddressEvent) {
      yield SearSearchAddressLoadingState();
      Response response =
          await _appBloc.httpService.searchAddress(event.address);
      if (response.statusCode == 200) {
        yield SearSearchAddressResultState(
          items: List.generate(
            response.data['features'].length,
            (index) => AddressSearchItem(
              displayName: response.data['features'][index]['properties']
                  ['display_name'],
              longitude: response.data['features'][index]['geometry']
                  ['coordinates'][0],
              latitude: response.data['features'][index]['geometry']
                  ['coordinates'][1],
            ),
          ),
        );
        // message: response.data['features']['properties']['display_name']);
      } else {
        yield SearSearchAddressErrorState(response.data.toString());
      }
    }
  }

  @override
  SearchAddressState get initialState => SearchAddressInitial();
}
