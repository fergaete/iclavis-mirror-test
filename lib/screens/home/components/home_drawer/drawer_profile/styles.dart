import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/shared/textstyles_shared.dart';

class DrawerProfileStyles extends TextStylesShared {
  InputDecoration get textFieldDecoration => InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            4.06.w,
          ),
        ),
        contentPadding: EdgeInsets.only(
          top: 8.5.h,
          left: 18.5.w,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.w,
            color: const Color(0xff999595),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.w,
            color: const Color(0xff999595),
          ),
        ),
      );

  BoxDecoration get iconDecoration => BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xff121212).withOpacity(.47),
      );

  RoundedRectangleBorder get bottomSheetShape => RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            20.w,
          ),
        ),
      );

  BoxDecoration get optionButtonDecoration => BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xff707070),
        ),
      );

  BoxDecoration profileImageDecoration(
          { String? defaultImage}) =>
      BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image:AssetImage(defaultImage??''),
          fit: BoxFit.cover,
        ),
      );
}
