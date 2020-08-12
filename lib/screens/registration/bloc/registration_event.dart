part of 'registration_bloc.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();
  @override
  List<Object> get props => [];
}

class RegChangePassFieldObscureValueEvent extends RegistrationEvent {
  final bool obscure;
  RegChangePassFieldObscureValueEvent({@required this.obscure});
  @override
  List<Object> get props => [obscure];
}

class RegCreateUserEvent extends RegistrationEvent {
  final String email;
  final String password;

  RegCreateUserEvent({@required this.email, @required this.password});

  @override
  List<Object> get props => [email, password];
}
