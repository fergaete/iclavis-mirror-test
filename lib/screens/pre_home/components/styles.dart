import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/shared.dart';

class PreHomeStyles extends TextStylesShared {
  BorderRadius get imageBorderRadius => BorderRadius.circular(
        4.w,
      );

  RoundedRectangleBorder get propertyInfoBorderRadius => RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            10.w,
          ),
        ),
      );
}
