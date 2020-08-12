import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_pet/global/http_service.dart';
import 'package:get_pet/global/models/user_permissions.dart';
import 'package:permission_handler/permission_handler.dart';

import '../data.dart';
import '../google_auth.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  Data data;
  // User user;
  // bool _isAuthorized;
  final HttpService httpService = HttpService();
  final Auth auth = Auth();
  final Geolocator _geolocator = Geolocator();
  UserPermissions userPermissions;
  FirebaseUser user;
  Position _position;
  Placemark _placemark;

  bool get isAuthorized => user?.uid != null;

  bool get isFirstAppLaunch => data.mainBox.toMap()['isFirstAppLaunch'] ?? true;

  Position get position => _position;

  Placemark get placemark => _placemark;

  Future<void> updateCurrentPlacemark(
          {double latitude, double longitude}) async =>
      await _geolocator
          .placemarkFromCoordinates(latitude, longitude)
          .then((value) => _placemark = value.first);

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    if (event is SuccessfulSignInEvent) {
      user = event.user;
      yield SuccessfulSignInState();
    } else if (event is SignOutEvent) {
      // user = User();
      // await data.mainBox.put('user', user.toMap);

      await auth.googleSignIn.isSignedIn().then((isSignedIn) async {
        if (isSignedIn) {
          await auth.googleSignIn.signOut();
        }
      });
      await auth.firebaseAuth.signOut();
      user = null;
      yield SignOutState();
    } else if (event is ClosedPermissionWindowEvent) {
      await Permission.location.isUndetermined.then((value) {
        if (value) {
          Permission.location.request();
        }
      });
      await data.mainBox.put('isFirstAppLaunch', false);
    }
  }

  @override
  AppState get initialState => AppInitial();

  Future<AppBloc> init() async {
    data = await Data().init();
    user = await auth.firebaseAuth.currentUser();
    // await data.mainBox.put('isFirstAppLaunch', true);
    userPermissions =
        UserPermissions.fromMap(data.mainBox.toMap()['user_permissions'] ?? {});
    if (await Permission.location.isGranted &&
        await _geolocator.isLocationServiceEnabled()) {
      _position = await _geolocator.getCurrentPosition();
      await _geolocator
          .placemarkFromPosition(_position)
          .then((value) => _placemark = value.first);
      // print('${_placcemark.first.locality}, ${_placcemark.first.country}');
    }

    return this;
  }
}
