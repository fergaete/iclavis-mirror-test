import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:iclavis/blocs/payment/payment_bloc.dart';
import 'package:iclavis/models/payment_model.dart';
import 'package:iclavis/utils/extensions/payment.dart';

import 'styles.dart';

final _styles = PaymentViewsStyles();

class DuesCard extends StatelessWidget {
  const DuesCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PaymentModel payment =
        (context.watch<PaymentBloc>().state as PaymentSuccess).result.data;

    final currentPaymentIndex =
        payment.negocios.indexWhere((p) => p.isCurrent!).hasCurrentPayment;

    final cuotas = payment.negocios[currentPaymentIndex].cuotas
        .where((e) =>
            e.estado!.contains('Sin Documentar') &
            e.fechaVencimiento!.isAfter(DateTime.now().add(Duration(days: 31))))
        .toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: cuotas.length,
      itemBuilder: (_, i) => Padding(
        padding: EdgeInsets.only(
          bottom: 10.h,
        ),
        child: Card(
          elevation: 4.h,
          color: Color(0xffffffff),
          shape: _styles.cardCircularBorder(4.w),
          child: SizedBox(
            width: 328.w,
            height: 54.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  cuotas[i].codigoTipoCuota??'',
                  style: _styles.mediumText(12.sp),
                ),
                Text(
                  cuotas[i].numero.toString(),
                  style: _styles.lightText(12.sp),
                ),
                Text(
                  DateFormat("dd-MM-yy").format(cuotas[i].fechaVencimiento!),
                  style: _styles.lightText(12.sp),
                ),
                Text(
                  "\$ ${NumberFormat.currency(locale: 'da-DK', symbol: '', decimalDigits: 0).format(cuotas[i].montoPesos)}",
                  style: _styles.mediumText(12.sp),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
