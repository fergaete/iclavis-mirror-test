import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/shared/textstyles_shared.dart';

class CustomDialogStyles extends TextStylesShared {
  RoundedRectangleBorder dialogShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(
      10.h,
    ),
  );
}
