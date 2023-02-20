import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

String formatNumberUf(num amount) {
  if (dotenv.env['COUNTRY_CODE'] == "PE") {
    return NumberFormat.currency(locale: 'es_PE', symbol: 'S/. ', customPattern: '\u00a4 #,###.#').format(double.tryParse(amount.toStringAsFixed(2))).replaceAll(',00', '');
  } else {
    return NumberFormat.currency(locale: 'es_CL', symbol: 'UF', decimalDigits: 2).format(double.tryParse(amount.toStringAsFixed(2))).replaceAll(',00', '');
  }
}
String formatNumber(num amount) {
  if (dotenv.env['COUNTRY_CODE'] == "PE") {
    return NumberFormat.currency( locale: 'es_PE', symbol: 'S/. ', customPattern: '\u00a4 #,###.#',decimalDigits: 0).format(double.tryParse(amount.toStringAsFixed(2))).replaceAll(',00', '');
  } else {
    return NumberFormat.currency(locale: 'es_CL',symbol: ' \$ ', customPattern: '\u00a4 #,###.#', decimalDigits: 0).format(amount);
  }
}
