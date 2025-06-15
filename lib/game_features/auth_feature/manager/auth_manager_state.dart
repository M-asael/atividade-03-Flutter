part of 'auth_manager_cubit.dart';

abstract class AuthManagerState extends Equatable {
  const AuthManagerState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthManagerState {}

class AuthLoading extends AuthManagerState {}

class AuthSuccess extends AuthManagerState {
  final Participant user;
  const AuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthFailure extends AuthManagerState {
  final String errorMessage;
  const AuthFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
