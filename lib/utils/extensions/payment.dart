import 'package:iclavis/utils/Translation/translation_extension.dart';

extension HasCurrentPayment on int {
  int get hasCurrentPayment => isNegative ? 0 : this;
}
String codeToText(String? code) {
  return 'codepay.$code'.i18n;
}
