import 'package:flutter/material.dart';

import '../environment.dart';

class CustomLocale {
  Iterable<Locale> defaultLocale() {

    final countryCode = Environment.COUNTRY_CODE ;
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
