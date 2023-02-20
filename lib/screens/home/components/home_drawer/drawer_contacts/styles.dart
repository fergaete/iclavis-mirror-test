import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/shared/textstyles_shared.dart';

class DrawerContactsStyles extends TextStylesShared {
  RoundedRectangleBorder get cardShape => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.w),
      );

  TextStyle get hoursText => regularText(14.sp, const Color(0xff171717));
}
