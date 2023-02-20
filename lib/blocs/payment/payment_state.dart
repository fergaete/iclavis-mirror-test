part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentInProgress extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final Result result;

  const PaymentSuccess({required this.result});

  @override
  List<Object> get props => [result];

  @override
  String toString() => 'PaymentSuccess { Reslt: $result }';
}

class PaymentFailure extends PaymentState {
  final Result result;

  const PaymentFailure({required this.result});

  @override
  List<Object> get props => [result];

  @override
  String toString() => 'PaymentFailure { Reslt: $result }';
}
