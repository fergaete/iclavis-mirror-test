import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/blocs/payment/payment_bloc.dart';
import 'package:iclavis/models/payment_model.dart';
import 'package:iclavis/shared/custom_icons.dart';
import 'package:iclavis/utils/utils.dart';

import 'styles.dart';

final _styles = PaymentViewsStyles();

class PaymentCard extends StatefulWidget {
  const PaymentCard({Key? key}) : super(key: key);

  @override
  _PaymentCard createState() => _PaymentCard();
}

class _PaymentCard extends State<PaymentCard> {
  late ScrollController _controller;
  late PaymentModel payment;

  int currentPropertyIndex = 0;

  List<LabeledGlobalKey> keys = [];

  @override
  void initState() {
    _controller = ScrollController();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    payment = (context.read<PaymentBloc>().state as PaymentSuccess).result.data;

    payment.negocios = payment.negocios
        .where((element) => element.promesa!.estado == "EMITIDA")
        .toList();
    payment.negocios
        .forEach((e) => keys.add(LabeledGlobalKey("${e.promesa!.id}")));

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.only(top: 16.h),
      child: Row(
        children: List.generate(
          payment.negocios.length,
          (i) => GestureDetector(
            child: Card(
              key: keys[i],
              elevation: 1.h,
              color:
                  i == currentPropertyIndex ? const Color(0xffe9e4dc) : Colors.white,
              shape: _styles.cardCircularBorder(4.w),
              margin: EdgeInsets.only(
                top: 4.h,
                bottom: 4.h,
                right: 9,
                left: 16.w,
              ),
              child: Container(
                width: 220.w,
                height: 91.h,
                padding: EdgeInsets.only(left: 8.w, right: 8.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              CustomIcons.i_departamento,
                              size: 18.h,
                            ),
                            Text(
                              payment.negocios[i].productoPrincipal?.tipo ?? '',
                              style: _styles.lightText(
                                14.sp,
                                const Color(0xff2F2F2F),
                              ),
                              textScaleFactor: 1.0,
                            ),
                          ],
                        ),
                        Expanded(
                          child: Text(
                            "${payment.negocios[i].productoPrincipal?.nombre}",
                            style: _styles.lightText(
                              14.sp,
                              const Color(0xff2F2F2F),
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            textScaleFactor: 1.0,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 3.w),
                      child: RichText(
                        text: TextSpan(
                          text: FlutterI18n.translate(context, "payments.total_title_card"),
                          style: _styles.lightText(16.sp),
                          children: <TextSpan>[
                            TextSpan(
                              text: formatNumberUf(payment.negocios[i].promesa?.total??0),
                              style: _styles.mediumText(16.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onTap: () async {
              context.read<PaymentBloc>().add(
                    CurrentPaymentSaved(id: payment.negocios[i].promesa!.id!),
                  );
              setState(() => currentPropertyIndex = i);

              final RenderObject? rb = keys[i].currentContext!.findRenderObject();

              await _controller.position.ensureVisible(
                rb!,
                alignment: 0.45,
                duration: Duration(milliseconds: 500),
                curve: Curves.ease,
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
