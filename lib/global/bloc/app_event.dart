part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class SuccessfulSignInEvent extends AppEvent {
  final FirebaseUser user;

  SuccessfulSignInEvent({@required this.user});
  @override
  List<Object> get props => [user];
}

class SignOutEvent extends AppEvent {}

class ClosedPermissionWindowEvent extends AppEvent {}
