import 'package:flutter/material.dart';


import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iclavis/utils/extensions/currency.dart';

import 'styles.dart';

final _styles = PaymentViewsStyles();

class PurchaseItem extends StatelessWidget {
  final IconData icon;
  final String item;
  final num amount;

  const PurchaseItem({
    Key? key,
    required this.icon,
    required this.item,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 6.h,
        bottom: 5.h,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(icon, size: 20.w),
          Text(
            item,
            style: _styles.lightText(12.sp),
            textScaleFactor: 1.0,
          ),
          Text(
            amount == 0 ? '-' :formatNumberUf(amount),
            style: _styles.mediumText(12.sp),
            textScaleFactor: 1.0,
          ),
        ],
      ),
    );
  }
}
