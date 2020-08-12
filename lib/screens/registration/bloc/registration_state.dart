part of 'registration_bloc.dart';

abstract class RegistrationState extends Equatable {
  final bool obscure;

  const RegistrationState({this.obscure = true});

  @override
  List<Object> get props => [obscure];
}

class RegistrationInitial extends RegistrationState {
  RegistrationInitial({bool obscure = true}) : super(obscure: obscure);
}

class RegChangePassFieldObscureValueState extends RegistrationState {
  RegChangePassFieldObscureValueState({bool obscure}) : super(obscure: obscure);
  // final bool obscure;
  // RegChangePassFieldObscureValueState({@required this.obscure});

  // @override
  // List<Object> get props => [obscure];
}

class RegCreateUserLoadingState extends RegistrationState {
  RegCreateUserLoadingState({bool obscure}) : super(obscure: obscure);
}

class RegCreateUserSuccessState extends RegistrationState {
  RegCreateUserSuccessState({bool obscure}) : super(obscure: obscure);
}

class RegCreateUserErrorState extends RegistrationState {
  final String errorMessage;
  RegCreateUserErrorState({
    bool obscure,
    this.errorMessage,
  }) : super(obscure: obscure);
}
