import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/widgets/widgets.dart';

import 'styles.dart';

final _styles = DrawerProfileStyles();

class UserProperty extends StatelessWidget {
  final String title, value;
  final bool? visible;

  UserProperty({
    required this.title,
    required this.value,
    this.visible,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: _styles.mediumText(14.sp),
      ),
      subtitle: Visibility(
        visible: visible ?? true,
        replacement: CustomTextField(
          attribute: title.toLowerCase(),
          decoration: _styles.textFieldDecoration,
        ),
        child: Text(
          value,
          style: _styles.lightText(14.sp),
        ),
      ),
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }
}
