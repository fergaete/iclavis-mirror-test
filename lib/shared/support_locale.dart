import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CustomLocale {
  Iterable<Locale> defaultLocale() {

    final countryCode = dotenv.env['COUNTRY_CODE'];
    if (countryCode == "PE") {
      return [
        const Locale('en', 'US'),
        const Locale('es', 'PE'),
        const Locale('es', 'CL'),
        const Locale('es', 'CO'),
      ];
    } else {
      return [
        const Locale('en', 'US'),
        const Locale('es', 'CL'),
        const Locale('es', 'CO'),
        const Locale('es', 'PE'),
      ];
    }
  }
}
