part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final UserModel? user;
  final error;

  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user,
    this.error,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated()
      : this._(status: AuthenticationStatus.authenticated);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  const AuthenticationState.error({dynamic error})
      : this._(status: AuthenticationStatus.error, error: error);

  @override
  List<Object> get props => [status, user??''];

  @override
  String toString() =>
      'AuthenticationState { status: $status, ${user.toString()} }';
}
