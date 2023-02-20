import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/shared/textstyles_shared.dart';

class NotificationsViewsStyles extends TextStylesShared {
  @override
  TextStyle mediumText(double size, [Color? color = const Color(0xff121212)]) =>
      super.mediumText(size, color);

  @override
  TextStyle regularText(double size, [Color? color = const Color(0xff121212)]) =>
      super.regularText(size, color);

  @override
  TextStyle lightText(double size, [Color? color = const Color(0xff121212)]) =>
      super.lightText(size, color);

  RoundedRectangleBorder cardCircularBorder(double radius) =>
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      );

  BoxDecoration get imageDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(4.w),
      );
}
