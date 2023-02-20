import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:iclavis/models/payment_model.dart';
import 'package:iclavis/blocs/payment/payment_bloc.dart';
import 'package:iclavis/utils/extensions/payment.dart';
import 'package:iclavis/utils/utils.dart';

import 'styles.dart';

final _styles = PaymentViewsStyles();

class AgreedItems extends StatelessWidget {
  const AgreedItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PaymentModel payment =
        (context.watch<PaymentBloc>().state as PaymentSuccess).result.data;

    final currentPaymentIndex =
        payment.negocios.indexWhere((p) => p.isCurrent!).hasCurrentPayment;

    final codes = payment.negocios[currentPaymentIndex].cuotas
        .where((e) => e.montoUf! > 0)
        .map((e) => e.codigoTipoCuota)
        .toSet()
        .toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(
        left: 10.w,
        right: 10.w,
      ),
      itemCount: codes.length,
      itemBuilder: (_, i) => Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              codeToText(codes[i]),
              style: _styles.lightText(14.sp),
              textScaleFactor: 1.0,
            ),
            Text(
              formatNumberUf(
                  calculateTotal(payment, currentPaymentIndex, codes[i] ?? '')),
              style: _styles.lightText(14.sp),
              textScaleFactor: 1.0,
            ),
          ],
        ),
      ),
    );
  }

  num calculateTotal(
      PaymentModel payment, int currentPaymentIndex, String code) {
    num total = 0;

    total = payment.negocios[currentPaymentIndex].cuotas
        .where((e) => e.codigoTipoCuota!.contains(code))
        .fold(0, (p, e) => p + e.montoUf!);

    return num.parse(total.toStringAsFixed(2));
  }
}
