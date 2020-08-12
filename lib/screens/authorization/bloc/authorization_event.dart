part of 'authorization_bloc.dart';

abstract class AuthorizationEvent extends Equatable {
  const AuthorizationEvent();

  @override
  List<Object> get props => [];
}

class AuthSignInWithGoogleEvent extends AuthorizationEvent {}

class AuthSignInWithLogPassEvent extends AuthorizationEvent {
  final String email;
  final String password;

  AuthSignInWithLogPassEvent({@required this.email, @required this.password});
}
