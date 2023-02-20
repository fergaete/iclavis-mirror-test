import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/shared/textstyles_shared.dart';

class HelpFormStyles extends TextStylesShared {
  InputDecoration get textAreaFieldDecoration => InputDecoration(
        filled: true,
        fillColor: Color(0xfff3f2f2),
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(
          top: 5.h,
          left: 39.7.w,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 1.h,
            color: Color(0xff999595),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 1.h,
            color: Color(0xff999595),
          ),
        ),
      );

  BoxDecoration get buttonBoxDecoration => BoxDecoration(
        color: Color(0xff999595).withOpacity(0.69),
        borderRadius: BorderRadius.all(
          Radius.circular(
            4.06.h,
          ),
        ),
      );
}
