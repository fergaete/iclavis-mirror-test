import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/shared/textstyles_shared.dart';

class ActionButtonStyles extends TextStylesShared {
  RoundedRectangleBorder shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(
        4.h,
      ),
    ),
  );
}
