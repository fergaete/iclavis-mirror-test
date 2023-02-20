import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:iclavis/utils/utils.dart';
import 'package:intl/intl.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'package:iclavis/blocs/payment/payment_bloc.dart';
import 'package:iclavis/models/payment_model.dart';
import 'package:iclavis/utils/extensions/payment.dart';
import 'package:iclavis/screens/home/components/tabbar_views/payment_views/payment_empty_card.dart';

import 'styles.dart';

final _styles = PaymentViewsStyles();

class FuturePayments extends StatelessWidget {
  const FuturePayments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String i18n(String text) => FlutterI18n.translate(context, text);

    PaymentModel payment =
        (context.watch<PaymentBloc>().state as PaymentSuccess).result.data;

    final currentPaymentIndex =
        payment.negocios.indexWhere((p) => p.isCurrent!).hasCurrentPayment;

    final cuotasPedientes = payment.negocios[currentPaymentIndex].cuotas
        .where((e) =>
            e.fechaVencimiento!
                .isBefore(DateTime.now().add(Duration(days: 31))) &
            (e.codigoTipoCuota != "CH"))
        .toList();

    final cuotas = payment.negocios[currentPaymentIndex].cuotas
        .where(
          (e) =>
              e.estado!.contains('Sin Documentar') &
              (e.codigoTipoCuota != "CH") &
              (payment.codigoConvenioOtrosPagos!.isEmpty
                  ? true
                  : e.fechaVencimiento!.isAfter(
                      DateTime.now().add(Duration(days: 31)),
                    )) &
              (e.montoPesos! > 0),
        )
        .toList();

    return cuotas.isEmpty
        ? cuotasPedientes.isEmpty ||
                (cuotasPedientes.isNotEmpty &&
                    payment.codigoConvenioOtrosPagos!.isEmpty)
            ? const PaymentEmptyCard(
                message: "No posee pagos pendientes",
              )
            : Container()
        : SizedBox(
            width: 336.w,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    left: 3.w,
                    bottom: 19.h,
                  ),
                  child: Text(
                    payment.codigoConvenioOtrosPagos!.isEmpty
                        ? i18n('payments.instalments_pay_title')
                        : i18n('payments.future_instalments_title'),
                    style: _styles.mediumText(14.sp),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 15.w,
                    bottom: 17.h,
                    right: 30.w,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        i18n('payments.definition_title'),
                        style: _styles.regularText(12.sp),
                        maxLines: 1,
                        textScaleFactor: 1.0,
                      ),
                      Text(
                        i18n('payments.instalment_title'),
                        style: _styles.regularText(12.sp),
                        maxLines: 1,
                        textScaleFactor: 1.0,
                      ),
                      Text(
                        i18n('payments.expiration_title'),
                        style: _styles.regularText(12.sp),
                        maxLines: 1,
                        textScaleFactor: 1.0,
                      ),
                      Text(
                        i18n('payments.amount_title'),
                        style: _styles.regularText(12.sp),
                        maxLines: 1,
                        textScaleFactor: 1.0,
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: cuotas.length,
                  itemBuilder: (_, i) => Padding(
                    padding: EdgeInsets.only(
                      bottom: 10.h,
                    ),
                    child: Card(
                      elevation: 4.h,
                      color: const Color(0xffffffff),
                      shape: _styles.cardCircularBorder(4.w),
                      child: SizedBox(
                        width: 328.w,
                        height: 54.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                                width: 65.w,
                                child: AutoSizeText(
                                  codeToText(cuotas[i].codigoTipoCuota),
                                  maxLines: 3,
                                  style: _styles.mediumText(10.sp),
                                  textScaleFactor: 1.0,
                                )),
                            Text(
                              cuotas[i].numero.toString(),
                              style: _styles.lightText(12.sp),
                              textScaleFactor: 1.0,
                            ),
                            Text(
                              DateFormat("dd-MM-yy")
                                  .format(cuotas[i].fechaVencimiento!),
                              style: _styles.lightText(12.sp),
                              textScaleFactor: 1.0,
                            ),
                            Text(
                              formatNumber(cuotas[i].montoPesos!),
                              style: cuotas[i]
                                      .fechaVencimiento!
                                      .isAfter(DateTime.now())
                                  ? _styles.mediumText(12.sp)
                                  : _styles.mediumText(12.sp, Colors.red),
                              textScaleFactor: 1.0,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
