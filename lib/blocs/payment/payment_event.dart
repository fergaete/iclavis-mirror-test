part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class PaymentAccountChanged extends PaymentEvent {}

class PaymentLoaded extends PaymentEvent {
  final String dni;
  final int id;
  final String apiKey;

  const PaymentLoaded({
    required this.dni,
    required this.id,
    required this.apiKey,
  });

  @override
  List<Object> get props => [dni, id, apiKey];

  @override
  String toString() => 'PaymentLoaded { DNI: $dni, Id: $id, apiKey: $apiKey }';
}

class CurrentPaymentSaved extends PaymentEvent {
  final int id;

  const CurrentPaymentSaved({
    required this.id,
  });

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'CurrentPaymentSaved { Id: $id }';
}
