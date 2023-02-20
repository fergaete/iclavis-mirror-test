import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/shared/custom_icons.dart';

import 'styles.dart';

final _styles = PaymentViewsStyles();

class PaymentEmptyCard extends StatelessWidget {
  final String? message;

  const PaymentEmptyCard({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.h,
      color: Color(0xffffffff),
      shape: _styles.cardCircularBorder(4.w),
      child: SizedBox(
        width: 328.w,
        height: 218.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              message ??
                  FlutterI18n.translate(context, "payments.no_payments_made"),
              textAlign: TextAlign.center,
              style: _styles.lightText(14.sp),
            ),
            Divider(thickness: 1),
            Icon(
              CustomIcons.i_pagos,
              size: 50.sp,
            ),
          ],
        ),
      ),
    );
  }
}
