import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:iclavis/blocs/payment/payment_bloc.dart';
import 'package:iclavis/models/payment_model.dart';
import 'package:iclavis/utils/Translation/translation_extension.dart';
import 'package:iclavis/utils/extensions/payment.dart';
import 'package:iclavis/utils/utils.dart';

import 'agreed_items.dart';
import 'styles.dart';

final _styles = PaymentViewsStyles();

class AgreedAmounts extends StatelessWidget {
  const AgreedAmounts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PaymentModel payment =
        (context.watch<PaymentBloc>().state as PaymentSuccess).result.data;

    final currentPaymentIndex =
        payment.negocios.indexWhere((p) => p.isCurrent!).hasCurrentPayment;

    return Card(
      elevation: 4.h,
      color: const Color(0xffffffff),
      shape: _styles.cardCircularBorder(4.w),
      child: Container(
        width: 328.w,
        padding: EdgeInsets.only(
          top: 7.h,
          bottom: 10.w,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "payments.agreed_amount_title".i18n,
              style: _styles.mediumText(16.sp, Color(0xff2F2F2F)),
            ),
            const AgreedItems(),
            const Divider(
              thickness: 1,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 10.w,
                right: 10.w,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "payments.total_title_card".i18n,
                    style: _styles.mediumText(16.sp, const Color(0xff2F2F2F)),
                    textScaleFactor: 1.0,
                  ),
                  Text(
                    formatNumberUf(payment.negocios[currentPaymentIndex].cuotas
                        .fold(0, (p, e) => p + e.montoUf!)),
                    style: _styles.mediumText(
                      18.sp,
                      const Color(0xff2F2F2F),
                    ),
                    textScaleFactor: 1.0,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
