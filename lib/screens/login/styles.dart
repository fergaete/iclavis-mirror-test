import 'package:flutter/widgets.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/shared/textstyles_shared.dart';

class LoginStyles extends TextStylesShared {
  italicOpenSansText(Color? color) => GoogleFonts.openSans(
        fontSize: 12.sp,
        fontStyle: FontStyle.italic,
        color: color ?? Color(0xff463E40),
      );
}
