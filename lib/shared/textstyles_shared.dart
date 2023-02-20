import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class TextStylesShared extends _BaseTextStyle {
  /// Optional variable color [Color color] default to the value of
  /// ```
  /// Color(0xff2F2F2F)
  /// ```
  TextStyle thinText(double size, [Color color = const Color(0xff2F2F2F)]) =>
      super._baseStyle(_thin, size, color);

  /// Optional variable color [Color color] default to the value of
  /// ```
  /// Color(0xff2F2F2F)
  /// ```
  TextStyle extraLightText(double size, [Color? color]) =>
      super._baseStyle(_extraLight, size, color);

  /// Optional variable color [Color color] default to the value of
  /// ```
  /// Color(0xff2F2F2F)
  /// ```
  TextStyle lightText(double size, [Color? color]) =>
      super._baseStyle(_light, size, color);

  /// Optional variable color [Color color] default to the value of
  /// ```
  /// Color(0xff2F2F2F)
  /// ```
  TextStyle regularText(double size, [Color? color]) =>
      super._baseStyle(_regular, size, color);

  /// Optional variable color [Color color] default to the value of
  /// ```
  /// Color(0xff2F2F2F)
  /// ```
  TextStyle mediumText(double size, [Color? color]) =>
      super._baseStyle(_medium, size, color);

  /// Optional variable color [Color color] default to the value of
  /// ```
  /// Color(0xff2F2F2F)
  /// ```
  TextStyle semiBoldText(double size, [Color? color]) =>
      super._baseStyle(_semiBold, size, color);

  /// Optional variable color [Color color] default to the value of
  /// ```
  /// Color(0xff2F2F2F)
  /// ```
  TextStyle boldText(double size, [Color? color]) =>
      super._baseStyle(_bold, size, color);

  /// Optional variable color [Color color] default to the value of
  /// ```
  /// Color(0xff2F2F2F)
  /// ```
  TextStyle extraBoldText(double size, [Color? color]) =>
      super._baseStyle(_extraBold, size, color);

  /// Optional variable color [Color color] default to the value of
  /// ```
  /// Color(0xff2F2F2F)
  /// ```
  TextStyle blackText(double size, [Color? color]) =>
      super._baseStyle(_black, size, color);
}

class _BaseTextStyle {
  TextStyle _baseStyle(FontWeight fontWeight, double size, [Color? color]) =>
      GoogleFonts.poppins(
        fontSize: size,
        fontWeight: fontWeight,
        color: color ?? const Color(0xff2F2F2F),
      );
}

const _thin = FontWeight.w100;
const _extraLight = FontWeight.w200;
const _light = FontWeight.w300;
const _regular = FontWeight.w400;
const _medium = FontWeight.w500;
const _semiBold = FontWeight.w600;
const _bold = FontWeight.w700;
const _extraBold = FontWeight.w800;
const _black = FontWeight.w900;
