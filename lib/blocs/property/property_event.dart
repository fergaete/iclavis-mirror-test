part of 'property_bloc.dart';

abstract class PropertyEvent extends Equatable {
  const PropertyEvent();

  @override
  List<Object> get props => [];
}

class PropertyChanged extends PropertyEvent {}

class PropertyLoaded extends PropertyEvent {
  final String dni;
  final int id;
  final String apiKey;

  const PropertyLoaded({
    required this.dni,
    required this.id,
    required this.apiKey,
  });

  @override
  List<Object> get props => [dni, id, apiKey];

  @override
  String toString() => 'PropertyLoaded { DNI: $dni, Id: $id, apiKey: $apiKey }';
}

class CurrentPropertySaved extends PropertyEvent {
  final int id;

  const CurrentPropertySaved({required this.id});

  @override
  List<Object> get props => [id];

  @override
  String toString() => "CurrentPropertySaved { Id: $id }";
}
