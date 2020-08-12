import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get_pet/global/bloc/app_bloc.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final AppBloc _appBloc;
  bool _obscure = true;

  RegistrationBloc(appBloc) : _appBloc = appBloc;

  @override
  RegistrationState get initialState => RegistrationInitial();

  @override
  Stream<RegistrationState> mapEventToState(
    RegistrationEvent event,
  ) async* {
    if (event is RegChangePassFieldObscureValueEvent) {
      _obscure = event.obscure;
      yield RegChangePassFieldObscureValueState(obscure: event.obscure);
    } else if (event is RegCreateUserEvent) {
      yield RegCreateUserLoadingState(obscure: _obscure);
      PlatformException er;
      AuthResult authResult;
      try {
        authResult = await _appBloc.auth.firebaseAuth
            .createUserWithEmailAndPassword(
                email: event.email, password: event.password);
      } on PlatformException catch (e) {
        er = e;
      }
      // await auth.firebaseAuth
      //     .createUserWithEmailAndPassword(
      //         email: event.email, password: event.password)
      // .then((value) => authResult = value, onError: (e) => er = e);
      if (er == null && authResult.user != null) {
        yield RegCreateUserSuccessState(obscure: _obscure);
        _appBloc.add(SuccessfulSignInEvent(user: authResult.user));
      } else {
        yield RegCreateUserErrorState(
            obscure: _obscure,
            errorMessage: er.code == 'ERROR_EMAIL_ALREADY_IN_USE'
                ? 'Пользователь с введенным e-mail уже существует.'
                : er.message);
      }
    }
  }
}
