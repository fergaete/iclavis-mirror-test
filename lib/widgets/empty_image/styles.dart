import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/shared/shared.dart';

class EmptyImageStyles extends TextStylesShared {
  RoundedRectangleBorder get emptyCardDecoration => RoundedRectangleBorder(
        side: BorderSide(color: Color(0xffE8E8E8)),
        borderRadius: BorderRadius.circular(4.w),
      );
}
