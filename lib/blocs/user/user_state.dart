part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserInProgress extends UserState {}

class UserSuccess extends UserState {
  final UserModel user;

  const UserSuccess({required this.user});

  @override
  List<UserModel> get props => [user];

  @override
  String toString() => 'UserSuccess { User: ${user.toJson()}}';
}

class UserFailure extends UserState {}
