import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:iclavis/screens/home/components/tabbar_views/payment_views/payment_empty_card.dart';
import 'package:iclavis/utils/validation/rut_validator.dart';
import 'package:iclavis/widgets/action_button/widget.dart';
import 'package:intl/intl.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:iclavis/blocs/user/user_bloc.dart';
import 'package:iclavis/models/user_model.dart';
import 'package:iclavis/models/payment_model.dart';
import 'package:iclavis/blocs/payment/payment_bloc.dart';
import 'package:iclavis/utils/extensions/payment.dart';

import 'styles.dart';

final _styles = PaymentViewsStyles();

class PaymentInfoCard extends StatelessWidget {
  const PaymentInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    String i18n(String text) => FlutterI18n.translate(context, text);
    UserModel user = (context.watch<UserBloc>().state as UserSuccess).user;

    PaymentModel payment =
        (context.watch<PaymentBloc>().state as PaymentSuccess).result.data;

    final currentPaymentIndex =
        payment.negocios.indexWhere((p) => p.isCurrent!).hasCurrentPayment;

    final cuotas = payment.negocios[currentPaymentIndex].cuotas
        .where((e) =>
            e.fechaVencimiento!
                .isBefore(DateTime.now().add(const Duration(days: 31))) &
            (e.codigoTipoCuota != "CH") &
            (e.montoPesos! > 0))
        .toList();

    return payment.negocios[currentPaymentIndex].cuotas.isEmpty
        ? PaymentEmptyCard(
            message: i18n("payments.no_pending_payments"),
          )
        : Visibility(
            visible: payment.codigoConvenioOtrosPagos!.isNotEmpty,
            child: Card(
              elevation: 4.h,
              color: const Color(0xffffffff),
              shape: _styles.cardCircularBorder(4.w),
              child: Container(
                width: 328.w,
                padding: EdgeInsets.only(
                  top: 17.h,
                  bottom: 40.h,
                ),
                child: Column(
                  children: [
                    Text(
                      payment.codigoConvenioOtrosPagos!.isEmpty
                          ? ''
                          : i18n("payments.instalments_pay_title"),
                      style: _styles.mediumText(14.sp),
                    ),
                    SizedBox(
                      width: 310.w,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                        ),
                        child: cuotas.isEmpty
                            ? Padding(
                                padding: EdgeInsets.only(top: 20.h),
                                child: Center(
                                  child: Text(
                                      i18n("payments.no_pending_payments"),
                                      textAlign: TextAlign.center,
                                      style: _styles.lightText(14.sp)),
                                ),
                              )
                            : DataTable(
                                dividerThickness: 0,
                                columnSpacing: 10.w,
                                horizontalMargin: 0,
                                dataRowHeight: 22.h,
                                showCheckboxColumn: false,
                                columns: [
                                  DataColumn(
                                    label: Text(
                                      i18n("payments.definition_title"),
                                      style: _styles.mediumText(12.sp),
                                      maxLines: 1,
                                      textScaleFactor: 1.0,
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      i18n("payments.instalment_title"),
                                      style: _styles.mediumText(12.sp),
                                      maxLines: 1,
                                      textScaleFactor: 1.0,
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      i18n("payments.expiration_title"),
                                      style: _styles.mediumText(12.sp),
                                      maxLines: 1,
                                      textScaleFactor: 1.0,
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      i18n("payments.amount_title"),
                                      style: _styles.mediumText(12.sp),
                                      maxLines: 1,
                                      textScaleFactor: 1.0,
                                    ),
                                  ),
                                ],
                                rows: cuotas
                                    .where((e) =>
                                        e.montoPesos! > 0 &&
                                        e.codigoTipoCuota != "CH")
                                    .map((c) {
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Text(
                                          codeToText(c.codigoTipoCuota ?? ''),
                                          style: _styles.lightText(
                                            10.sp,
                                            const Color(0xff121212),
                                          ),
                                          maxLines: 1,
                                          textScaleFactor: 1.0,
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          "${c.numero}",
                                          style: _styles.lightText(
                                            12.sp,
                                            const Color(0xff121212),
                                          ),
                                          maxLines: 1,
                                          textScaleFactor: 1.0,
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          DateFormat("dd-MM-yy")
                                              .format(c.fechaVencimiento!),
                                          style: _styles.lightText(
                                            12.sp,
                                            const Color(0xff121212),
                                          ),
                                          maxLines: 1,
                                          textScaleFactor: 1.0,
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          "\$ ${NumberFormat.currency(locale: 'da-DK', symbol: '', decimalDigits: 0).format(c.montoPesos)}",
                                          style: _styles.lightText(
                                            12.sp,
                                            const Color(0xff121212),
                                          ),
                                          maxLines: 1,
                                          textScaleFactor: 1.0,
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                      ),
                    ),
                    Container(
                      height: 36.h,
                      width: 286.w,
                      margin: EdgeInsets.only(top: 20.h),
                      child: ActionButton(
                        label: i18n("payments.pay"),
                        labelStyle: _styles.mediumText(
                          18.sp,
                          Color(0xffFFFFFF),
                        ),
                        isEnabled: true,
                        onPressed: () => _launchPay(
                          "https://otrospagos.com/publico/portal/enlace?"
                          "id=${payment.codigoConvenioOtrosPagos}&"
                          "idcli=${user.dni!.replaceAll('-', '')}${RutValidatorUtil().getCheckDigit(user.dni!.replaceAll('-', ''))}&"
                          "tiidc=05",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Future _launchPay(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }
}
