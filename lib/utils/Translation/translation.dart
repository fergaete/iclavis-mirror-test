import 'package:flutter/widgets.dart';

import 'package:flutter_i18n/flutter_i18n.dart';

class Translation {
  late BuildContext _context;

  static final Translation _singleton = Translation._internal();

  Translation._internal();

  factory Translation(BuildContext context) {
    _singleton._context = context;
    return _singleton;
  }

  static Translation get inst => _singleton;

  String translate(String text) => FlutterI18n.translate(_context, text);


}
