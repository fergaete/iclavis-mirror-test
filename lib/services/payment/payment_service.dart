import 'package:dio/dio.dart';

import 'package:iclavis/utils/http/http_manager.dart';

import 'package:iclavis/models/payment_model.dart';

class PaymentService {
  Future<PaymentModel> fetchPayment(String dni, int id, String apiKey) async {
    final httpClient = HttpManager.instance.withToken;

    Response response = await httpClient.get(
      "/datos-forma-pago",
      queryParameters: {'rutDNI': dni, 'idProyecto': id, 'apiKey': apiKey},
    );

    return paymentModelFromJson(response.data);
  }
}
