import 'package:flutter/material.dart';
import 'package:iclavis/utils/utils.dart';
import 'package:intl/intl.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/blocs/payment/payment_bloc.dart';
import 'package:iclavis/models/payment_model.dart';
import 'package:iclavis/utils/extensions/payment.dart';

import 'payment_empty_card.dart';
import 'styles.dart';

final _styles = PaymentViewsStyles();

class PaymentsMade extends StatelessWidget {
  const PaymentsMade({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PaymentModel payment =
        (context.watch<PaymentBloc>().state as PaymentSuccess).result.data;

    final currentPaymentIndex =
        payment.negocios.indexWhere((p) => p.isCurrent!).hasCurrentPayment;

    final cuotas = payment.negocios[currentPaymentIndex].cuotas
        .where((e) =>
            e.estado!.contains('Documentada Completa') ||
            e.estado!.contains('Documentada Incompleta'))
        .toList();

    if (cuotas.isEmpty) return const PaymentEmptyCard();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cuotas.length,
      itemBuilder: (_, i) {
        final pagosConciliado = cuotas[i]
            .pagos
            .where((e) => e.estadoDocumento!.contains("CONCILIADO"))
            .toList();
        if (pagosConciliado.isEmpty) {
          return cuotas.length == 1 ? const PaymentEmptyCard() : Container();
        } else {
          return Padding(
            padding: EdgeInsets.only(
              left: 12.w,
              right: 12.w,
              bottom: 10.h,
            ),
            child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: pagosConciliado.length,
                itemBuilder: (_, j) {
                  return Card(
                    elevation: 4.h,
                    color: const Color(0xffffffff),
                    shape: _styles.cardCircularBorder(4.w),
                    child: Container(
                      height: 99.h,
                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                codeToText(cuotas[i].codigoTipoCuota??''),
                                style: _styles.mediumText(14.sp),
                              ),
                              Text(
                                "${cuotas[i].numero}",
                                style: _styles.mediumText(14.sp),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: "ID:",
                                  style: _styles.mediumText(14.sp),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "${pagosConciliado[j].id}",
                                      style: _styles.lightText(
                                        12.sp,
                                        const Color(0xff777777),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                DateFormat("dd-MM-yy").format(
                                    DateTime.parse(pagosConciliado[j].fecha??'')),
                                style: _styles.lightText(12.sp),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                pagosConciliado[j].tipoDocumento??'',
                                style: _styles.lightText(
                                  14.sp,
                                ),
                              ),
                              Text(
                                formatNumberUf(pagosConciliado[j].monto??0),
                                style: _styles.mediumText(14.sp),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          );
        }
      },
    );
  }
}
