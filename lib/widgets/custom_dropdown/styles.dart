import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/shared/textstyles_shared.dart';

class CustomDropdownStyles extends TextStylesShared {
  InputDecoration get dropdownDecoration => InputDecoration(
        filled: true,
        fillColor: Color(0xff999595).withOpacity(.12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            4.06.w,
          ),
        ),
        contentPadding: EdgeInsets.only(
          left: 44.w,
          top: 10.h,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.w,
            color: Color(0xff999595),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.w,
            color: Color(0xff999595),
          ),
        ),
      );

  BoxDecoration boxDecoration = BoxDecoration(
    color: Colors.white,
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
