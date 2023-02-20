part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UserLoaded extends UserEvent {}

class UserUpdated extends UserEvent {
  final UserModel user;

  const UserUpdated({required this.user});

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'UserUpdated { User $user }';
}

class UserRemoved extends UserEvent {}
