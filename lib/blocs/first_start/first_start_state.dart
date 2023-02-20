part of 'first_start_bloc.dart';

abstract class FirstStartState extends Equatable {
  const FirstStartState();

  @override
  List<Object> get props => [];
}

class FirstStartSuccess extends FirstStartState {
  final bool hasFirstStart;

  const FirstStartSuccess({required this.hasFirstStart});

  @override
  List<bool> get props => [hasFirstStart];

  @override
  String toString() => 'FirstStartSuccess { hasFirstStart: $hasFirstStart}';
}

class FirstStartFailure extends FirstStartState {}
class FirstStartInitial extends FirstStartState {}
