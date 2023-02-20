part of 'property_bloc.dart';

abstract class PropertyState extends Equatable {
  const PropertyState();

  @override
  List<Object> get props => [];
}

class PropertyInitial extends PropertyState {}

class PropertyInProgress extends PropertyState {}

class PropertySuccess extends PropertyState {
  final Result result;

  const PropertySuccess({required this.result});

  @override
  List<Object> get props => [result];

  @override
  String toString() => "PropertySuccess { Result $result }";
}

class PropertyFailure extends PropertyState {
  final Result result;

  const PropertyFailure({required this.result});

  @override
  List<Object> get props => [result];

  @override
  String toString() => "PropertyFailure { Result $result }";
}
