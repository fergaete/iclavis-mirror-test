import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/shared/shared.dart';

final _styles = TextStylesShared();

class InputInfo extends StatelessWidget {
  final bool visible;
  final String label;
  final Icon? icon;
  final Widget? link;
  final VoidCallback? onPressed;
  final EdgeInsets? margin;
  final dynamic styles;
  final Color? color;

  const InputInfo({
    this.visible = true,
    required this.label,
    this.icon,
    this.link,
    this.onPressed,
    this.margin,
    this.styles,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Container(
        margin: margin,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 2,
                textAlign: TextAlign.left,
                style: styles ??
                    _styles
                        .lightText(12.sp, color ?? Color(0xff463E40))
                        .copyWith(height: 0),
              ),
            ),

            /* SizedBox(
              width: 4.w,
            ), */
            Icon(
              icon?.icon ?? CustomIcons.i_ayuda,
              color: color ?? Colors.black,
              size: 12.62.sp,
            ),
            Container(child: link),
          ],
        ),
      ),
    );
  }
}
