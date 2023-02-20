import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'styles.dart';

final _styles = DrawerProfileStyles();

class OptionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  OptionButton({
    Key? key,
    required this.label,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 60.w,
            height: 60.w,
            margin: EdgeInsets.only(
              bottom: 6.h,
            ),
            decoration: _styles.optionButtonDecoration,
            child: Icon(
              icon,
              size: 55.sp,
              color: Colors.black,
            ),
          ),
        ),
        Text(
          label,
          style: _styles.lightText(14.sp),
        ),
      ],
    );
  }
}
