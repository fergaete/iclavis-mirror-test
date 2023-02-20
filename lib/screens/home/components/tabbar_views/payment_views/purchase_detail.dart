import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/blocs/payment/payment_bloc.dart';
import 'package:iclavis/models/payment_model.dart';
import 'package:iclavis/utils/extensions/payment.dart';
import 'package:iclavis/shared/custom_icons.dart';

import 'purchase_item.dart';
import 'styles.dart';

final _styles = PaymentViewsStyles();

class PurchaseDetail extends StatelessWidget {
  const PurchaseDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String i18n(String text) => FlutterI18n.translate(context, text);
    PaymentModel payment =
        (context.watch<PaymentBloc>().state as PaymentSuccess).result.data;

    final currentPaymentIndex =
        payment.negocios.indexWhere((p) => p.isCurrent!).hasCurrentPayment;

    return Card(
      elevation: 4.h,
      color: Color(0xffffffff),
      shape: _styles.cardCircularBorder(4.w),
      child: Container(
        width: 328.w,
        height: 113.h,
        padding: EdgeInsets.only(
          left: 10.w,
        ),
        child: Row(
          children: [
            PurchaseItem(
              icon: CustomIcons.i_departamento,
              item:StringUtils.capitalize( payment
                  .negocios[currentPaymentIndex].productoPrincipal?.tipo??i18n("payments.apartment")),
              amount: payment
                  .negocios[currentPaymentIndex].productoPrincipal?.precio??0,
            ),
            SizedBox(
              height: 70.h,
              child: const VerticalDivider(),
            ),
            PurchaseItem(
              icon: CustomIcons.i_estacionamiento,
              item: i18n("payments.parking"),
              amount: calculateAmountSecondaryProducts(
                  payment.negocios[currentPaymentIndex].productosSecundarios,
                  'estacionamiento')??0,
            ),
            SizedBox(
              height: 70.h,
              child: const VerticalDivider(),
            ),
            SizedBox(
              width: 90.w,
              child: PurchaseItem(
                icon: CustomIcons.i_bodega,
                item: i18n("payments.storage"),
                amount: calculateAmountSecondaryProducts(
                    payment.negocios[currentPaymentIndex].productosSecundarios,
                    'bodega')??0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  num? calculateAmountSecondaryProducts(
      List<ProductosSecundario> productosSecundarios, String type) {
    final secondaryProducts = productosSecundarios
        .where((e) => e.tipo!.toLowerCase().contains(type))
        .map((e) => e.precio);

    return secondaryProducts.isEmpty
        ? 0
        : secondaryProducts.reduce((v, e) => v! + e!);
  }
}
