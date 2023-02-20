import 'package:flutter/material.dart';

import 'package:iclavis/personalizacion.dart';

import '../../shared/shared.dart';

class OnboardingStyles extends TextStylesShared {
  indicator(bool positionMatches) => BoxDecoration(
        shape: BoxShape.circle,
        color: positionMatches ? Customization.variable_1 : Color(0xffF0F0F0),
      );

  @override
  TextStyle mediumText(double size, [Color? color = const Color(0xff1A2341)]) {
    return super.mediumText(size, color);
  }

  @override
  TextStyle regularText(double size, [Color? color = const Color(0xff1A2341)]) {
    return super.regularText(size, color);
  }
}
