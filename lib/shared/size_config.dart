import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class SizeConfig {
  static void init(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(1280,720),
      minTextAdapt: true,
    );
  }
}
