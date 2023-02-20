import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iclavis/widgets/help_form/styles.dart';

class AlertWidget extends StatelessWidget {

  final String? text;
  AlertWidget({super.key, this.text});

  final _styles = HelpFormStyles();
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10.w),
        margin: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.w),
          color: const Color(0xFFF4F7F8),
        ),
        child:Row(
          children: [
            const Icon(Icons.info,color: Color(0xFF9A9A9A),),
            SizedBox(width: 5.w,),
            Expanded(child: Text(text??'',
              style:  _styles.lightText(12.sp, Color(0xff463E40)),
            ))
          ],
        ),
    );
  }
}
