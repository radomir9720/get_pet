import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get_pet/global/bloc/app_bloc.dart';

part 'authorization_event.dart';
part 'authorization_state.dart';

class AuthorizationBloc extends Bloc<AuthorizationEvent, AuthorizationState> {
  final AppBloc _appBloc;

  AuthorizationBloc(this._appBloc);
  @override
  AuthorizationState get initialState => AuthorizationInitial();

  @override
  Stream<AuthorizationState> mapEventToState(
    AuthorizationEvent event,
  ) async* {
    if (event is AuthSignInWithGoogleEvent) {
      PlatformException err;
      yield AuthSignInWithGoogleLoadingState();

      try {
        FirebaseUser firebaseUser = await _appBloc.auth.signInWithGoogle();
        if (firebaseUser != null) {
          _appBloc.add(SuccessfulSignInEvent(user: firebaseUser));
        }
      } on PlatformException catch (e) {
        err = e;
      }
      if (err != null) {
        yield AuthSignInWithGoogleErrorState(err.message);
      } else {
        yield AuthSignInWithGoogleSuccessState();
      }
    } else if (event is AuthSignInWithLogPassEvent) {
      PlatformException err;
      yield AuthSignInWithLogPassLoadingState();
      try {
        AuthResult authResult = await _appBloc.auth.firebaseAuth
            .signInWithEmailAndPassword(
                email: event.email, password: event.password);
        if (authResult.user != null) {
          _appBloc.add(SuccessfulSignInEvent(user: authResult.user));
        }
      } on PlatformException catch (e) {
        err = e;
      }
      if (err != null) {
        yield AuthSignInWithLogPassErrorState(err.message);
      } else {
        yield AuthSignInWithLogPassSuccessState();
      }
    }
  }
}
