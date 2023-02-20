import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/shared.dart';

class UserVerificationStyles extends TextStylesShared {
  Border get border => Border.all(
        width: 1,
        color: Color(0xff999595),
        style: BorderStyle.solid,
      );

  BorderRadius get slidingBorderRadius => BorderRadius.vertical(
        top: Radius.circular(10.w),
      );

  BorderRadius get borderRadiusPinCode => BorderRadius.circular(4.w);

  TextStyle get errorInfoText => lightText(12.sp, Color(0xffe91d2c));
}
