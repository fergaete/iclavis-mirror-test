import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'styles.dart';

final _styles = DrawerPropertyStyles();

class Feature extends StatelessWidget {
  final IconData icon;

  final String feature;
  final String value;

  const Feature({
    Key? key,
    required this.icon,
    required this.feature,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 14.h),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            size: 20.w,
            color: Colors.black,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 23.54.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    feature,
                    style: _styles.lightText(14.sp),
                  ),
                  Text(
                    value,
                    style: _styles.regularText(14.sp, const Color(0xff131212)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
