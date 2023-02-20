import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/personalizacion.dart';
import 'package:iclavis/shared/textstyles_shared.dart';

class CustomTextFieldStyles extends TextStylesShared {
  InputDecoration textFieldDecoration(Color borderColor) => InputDecoration(
        filled: true,
        fillColor: Customization.variable_6,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            4.06.w,
          ),
        ),
        contentPadding: EdgeInsets.only(
          top: 10.h,
          right: 5.w,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: borderColor,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: borderColor,
          ),
        ),
      );

  BoxDecoration boxDecoration(Color iconBackgroundColor) => BoxDecoration(
        color: iconBackgroundColor ,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            4.06.w,
          ),
          bottomLeft: Radius.circular(
            4.06.w,
          ),
        ),
      );
}
