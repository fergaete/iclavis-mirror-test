import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iclavis/utils/Translation/translation_extension.dart';

import 'package:iclavis/widgets/widgets.dart';

import '../../../utils/Translation/translation.dart';
import 'styles.dart';

final _styles = PreHomeStyles();

class PreHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PreHomeAppBar({super.key});

  @override
  Size get preferredSize {
    return Size.fromHeight(58.h);
  }

  @override
  Widget build(BuildContext context) {
    Translation(context);
    return CustomSizeAppBar(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "pre_home.title_prehome".i18n,
          style: _styles.lightText(18.sp, const Color(0xff463E40)),
        ),
        centerTitle: true,
      ),
    );
  }
}
