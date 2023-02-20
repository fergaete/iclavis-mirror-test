import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:iclavis/shared/textstyles_shared.dart';

final _styles = TextStylesShared();

class EmptyCard extends StatelessWidget {
  final String text;
  final IconData? icon;
  final String? svg;
  final Color? color;

  const EmptyCard({
    Key? key,
    required this.text,
    this.icon,
    this.svg,
    this.color,
  })  : assert(
          icon != null && svg == null ||
              icon == null && svg != null ||
              icon == null && svg == null,
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.h,
      color: Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: SizedBox(
        width: 328.w,
        height: 218.h,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              constraints: BoxConstraints(minHeight: 77.5.h),
              padding: const  EdgeInsets.all(12),
              child: Text(
                text,
                style: _styles.lightText(14.sp, Color(0xff121212)),
                textAlign: TextAlign.center,
              ),
            ),
            Divider(thickness: 1),
            Visibility(
              visible: svg != null,
              child: Expanded(
                child: SvgPicture.asset(
                  svg ?? '',
                  width: 50.w,
                  height: 50.w,
                ),
              ),
            ),
            Visibility(
              visible: icon != null,
              child: Expanded(
                child: Icon(
                  icon,
                  size: 50.sp,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
