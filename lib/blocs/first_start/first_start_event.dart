part of 'first_start_bloc.dart';

abstract class FirstStartEvent extends Equatable {
  const FirstStartEvent();

  @override
  List<Object> get props => [];
}

class FirstStartFlagSaved extends FirstStartEvent {}

class FirstStartFlagLoaded extends FirstStartEvent {}
