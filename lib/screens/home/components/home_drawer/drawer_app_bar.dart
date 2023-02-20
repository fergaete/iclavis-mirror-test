import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iclavis/personalizacion.dart';

import 'package:iclavis/widgets/widgets.dart';
import 'package:iclavis/shared/custom_icons.dart';
import 'package:iclavis/shared/textstyles_shared.dart';

final _styles = TextStylesShared();

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const ProfileAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Size get preferredSize {
    return Size.fromHeight(56.h);
  }

  @override
  Widget build(BuildContext context) {
    return CustomSizeAppBar(
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
          child: Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: Icon(
              CustomIcons.i_volver_atras,
              size: 16.sp,
              color: Customization.variable_2,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          title,
          style: _styles.lightText(18.sp, Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
    );
  }
}
