import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/shared/custom_icons.dart';

class SaveButton extends StatelessWidget {
  final bool isEditting;
  final Function onPressed;

  const SaveButton({
    Key? key,
    required this.isEditting,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 47.h),
      child: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => onPressed(),
        child: Icon(
          isEditting ? CustomIcons.i_check : CustomIcons.i_editar,
          size: 15.sp,
          color: Colors.black,
        ),
      ),
    );
  }
}
