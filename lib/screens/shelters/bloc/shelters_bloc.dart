import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_pet/global/bloc/app_bloc.dart';
import 'package:get_pet/global/models/address_search_item.dart';
import 'package:get_pet/global/models/shelter.dart';
import 'package:get_pet/global/utilities.dart';
import 'package:image_picker/image_picker.dart';

part 'shelters_event.dart';
part 'shelters_state.dart';

class SheltersBloc extends Bloc<SheltersEvent, SheltersState> {
  final AppBloc _appBloc;
  final ImagePicker _imagePicker = ImagePicker();
  PickedFile _imageForAddingShelter;

  PickedFile get imageForAddingShelter => _imageForAddingShelter;

  SheltersBloc(this._appBloc);
  @override
  SheltersState get initialState => SheltersInitial();

  @override
  Stream<SheltersState> mapEventToState(
    SheltersEvent event,
  ) async* {
    if (event is ShelOpenModalBottomSheetEvent) {
      yield ShelOpenModalBottomSheetState();
    } else if (event is ShelCloseModalBottomSheetEvent) {
      yield ShelCloseModalBottomSheetState();
    } else if (event is ShelAddNewShelterEvent) {
      yield* _addNewShelter(event);
    } else if (event is ShelSearchSheltersEvent) {
      yield* _searchShelters();
    } else if (event is ShelSelectAddressEvent) {
      yield ShelSelectAddressState(event.addressSearchItem);
    } else if (event is ShelSelectAddressChangeLocationEvent) {
      await _appBloc.updateCurrentPlacemark(
          latitude: event.addressSearchItem.latitude,
          longitude: event.addressSearchItem.longitude);
      yield ShelSelectAddressChangeLocationState(
          event.addressSearchItem.displayName);
      add(ShelSearchSheltersEvent());
    } else if (event is ShelPickPhotoForAddingShelterEvent) {
      _imageForAddingShelter =
          await _imagePicker.getImage(source: ImageSource.gallery);
      yield ShelPickPhotoForAddingShelterState(
          _imageForAddingShelter.path.split('/').last);
      // await _appBloc.httpService
      //     .uploadImageToBucket(_imageForAddingShelter)
      //     .then((value) => print(value.toString()));
    }
  }

  Stream<SheltersState> _searchShelters() async* {
    yield ShelSearchSheltersLoadingState();
    Response response = await _appBloc.httpService.searchShelters(
        _appBloc.placemark.position.latitude.toString(),
        _appBloc.placemark.position.longitude.toString());
    if (response.statusCode == 200) {
      yield ShelSearchSheltersSuccessState(
        shelters: response.data
            .map(
              (e) => Shelter.fromMap(e),
            )
            .cast<Shelter>()
            .toList(),
      );
    } else {
      yield ShelSearchSheltersErrorState(response.data.toString());
    }
  }

  Stream<SheltersState> _addNewShelter(ShelAddNewShelterEvent event) async* {
    yield ShelAddNewShelterLoadingState();
    Map data = {
      'shelter_name': event.shelter.shelterName,
      'phone': event.shelter.phoneNumber,
      'added_by': _appBloc.user.email,
      'add_timestamp': DateTime.now().millisecondsSinceEpoch,
      'address': event.shelter.addressSearchItem.displayName,
      'longitude': event.shelter.addressSearchItem.longitude.toString(),
      'latitude': event.shelter.addressSearchItem.latitude.toString(),
    };
    if (event.shelter.site != null && event.shelter.site.isNotEmpty) {
      data['site'] = event.shelter.site;
    }
    if (_imageForAddingShelter != null) {
      data['base64_image'] = await imageToBase64(_imageForAddingShelter);
    }
    Response response = await _appBloc.httpService.addNewShelter(data);
    if (response.statusCode == 200 &&
        jsonDecode(response.data)['Reply'] == 'Ok') {
      yield ShelAddNewShelterSuccessState();
    } else {
      yield ShelAddNewShelterErrorState(response.data.toString());
    }
  }
}
