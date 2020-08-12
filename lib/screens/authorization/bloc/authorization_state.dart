part of 'authorization_bloc.dart';

abstract class AuthorizationState extends Equatable {
  const AuthorizationState();
  @override
  List<Object> get props => [];
}

class AuthorizationInitial extends AuthorizationState {}

class AuthSignInWithGoogleLoadingState extends AuthorizationState {}

class AuthSignInWithGoogleSuccessState extends AuthorizationState {}

class AuthSignInWithGoogleErrorState extends AuthorizationState {
  final String errorMessage;

  AuthSignInWithGoogleErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class AuthSignInWithLogPassLoadingState extends AuthorizationState {}

class AuthSignInWithLogPassSuccessState extends AuthorizationState {}

class AuthSignInWithLogPassErrorState extends AuthorizationState {
  final String errorMessage;

  AuthSignInWithLogPassErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
