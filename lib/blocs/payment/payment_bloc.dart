import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'package:iclavis/services/payment/payment_repository.dart';
import 'package:iclavis/utils/http/result.dart';
import 'package:iclavis/models/payment_model.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends HydratedBloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(PaymentInitial()){

    on<PaymentLoaded>((event, emit) async {
      emit(PaymentInProgress());

      try {
        final result = await paymentRepository.fetchPayments(
          dni: event.dni,
          id: event.id,
          apiKey: event.apiKey,
        );

        emit(PaymentSuccess(result: result));
      } on ResultException catch (e) {
        emit(PaymentFailure(result: e.result!));
      }
    });
    on<CurrentPaymentSaved>((event, emit) async {
      try {
        PaymentModel payment = (state as PaymentSuccess).result.data;

        final negocios = payment.negocios.map((p) {
          if (p.promesa!.id == event.id) {
            if (!p.isCurrent!) {
              return p.copyWith(isCurrent: true);
            } else {
              return p;
            }
          } else {
            return p.copyWith(isCurrent: false);
          }
        }).toList();

        final data = payment.copyWith(negocios: negocios);

        Result result = Result(data: data, message: 'isCurrent payment changed!');

        emit(PaymentSuccess(result: result));
      } catch (_) {
        emit(PaymentFailure(
            result: Result(message: 'Error in CurrentPaymentSaved')));
      }
    });
    on<PaymentAccountChanged>((event, emit) async {
      emit(PaymentInitial());
    });
  }

  final PaymentRepository paymentRepository = PaymentRepository();


  @override
  PaymentState? fromJson(Map<String, dynamic> data) {
    try {
      final payment = paymentModelFromJson(json.decode(data['value']));

      return PaymentSuccess(result: Result(data: payment));
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(PaymentState state) {
    if (state is PaymentSuccess) {
      return {'value': paymentModelToJson(state.result.data)};
    } else {
      return null;
    }
  }
}
