import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/shared/textstyles_shared.dart';

class DrawerPropertyStyles extends TextStylesShared {
  BoxDecoration get companyDecoration => const BoxDecoration(
        shape: BoxShape.rectangle,
        color: Color(0xffe9e4dc),
      );

  BoxDecoration get blueprintDecoration => BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(
          width: 3.w,
          color: Color(0xff707070),
        ),
      );

  BorderRadius get imageBorderRadius => BorderRadius.vertical(
        top: Radius.circular(4.w),
        bottom: Radius.circular(10.w),
      );

  RoundedRectangleBorder get slideBorder => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.w),
      );

  RoundedRectangleBorder get propertyCardBorder => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.w),
      );
}
