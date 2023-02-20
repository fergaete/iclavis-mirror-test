import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iclavis/personalizacion.dart';

import 'package:iclavis/shared/textstyles_shared.dart';

class HomeViewsStyles extends TextStylesShared {
  BoxDecoration circleShape(bool isMilestoneCompleted, Color colorCompleted) =>
      BoxDecoration(
        color:
        isMilestoneCompleted == true ? colorCompleted : Color(0xffe9e4dc),
        shape: BoxShape.circle,
      );

  RoundedRectangleBorder get newsCardBorder => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.w),
      );

  RoundedRectangleBorder get homeCardBorder => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.w),
      );

  BorderRadius get homeCardBorderRadius => BorderRadius.vertical(
        top: Radius.circular(4.w),
      );

  BoxDecoration indicatorDecoration(bool isCurrentPage) => BoxDecoration(
        shape: BoxShape.circle,
        color:
            isCurrentPage ? Customization.variable_1 : Customization.variable_4,
      );
}
