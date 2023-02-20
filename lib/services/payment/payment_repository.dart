import 'package:iclavis/utils/http/exception_handler.dart';
import 'package:iclavis/utils/http/result.dart';

import 'payment_service.dart';

class PaymentRepository {
  final _paymentService = PaymentService();
  final _handler = ExceptionHandler();

  Future<Result> fetchPayments({required String dni, required int id, required String apiKey}) async {
    try {
      final payments = await _paymentService.fetchPayment(
        dni,
        id,
        apiKey,
      );

      return Result(data: payments);
    } catch (e) {
      throw _handler.analyzeException(error: e);
    }
  }
}
