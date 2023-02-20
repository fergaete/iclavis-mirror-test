import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iclavis/personalizacion.dart';

import 'package:iclavis/shared/custom_icons.dart';
import 'package:iclavis/utils/Translation/translation_extension.dart';
import 'package:iclavis/utils/extensions/analytics.dart';

import 'styles.dart';

final _styles = PaymentViewsStyles();

class PaymentStateCard extends StatefulWidget {
  final TabController tabController;
  final double itemWidth;

  const PaymentStateCard({
    Key? key,
    required this.tabController,
    required this.itemWidth,
  }) : super(key: key);

  @override
  _PaymentStateCardState createState() => _PaymentStateCardState();
}

class _PaymentStateCardState extends State<PaymentStateCard> with SingleTickerProviderStateMixin  {
  int currentOption = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 344.w,
      height: 100.w,
      child:
        TabBar(
          controller: widget.tabController,
          indicatorColor: Colors.transparent,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          labelPadding: const EdgeInsets.all(0),
          onTap: (i)=>setState(()=> currentOption=i),
          tabs: [
            tabOption(currentOption,0),
            tabOption(currentOption,1),
            tabOption(currentOption,2),
          ],
        ),

    );
  }

  Widget tabOption(int currentOption, int i){
    return Card(
        elevation: 1.h,
        color:currentOption == i
            ? Customization.variable_2
            : const Color(0xffe9e4dc),
        shape: _styles.cardCircularBorder(4.w),
        child: SizedBox(
          width: 102.w,
          height: 87.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                CustomIcons.i_conceptual,
                size: 24.w,
                color: currentOption == i
                    ? Customization.variable_4
                    : const Color(0xFF2F2F2F),
              ),
              Text(
                paymentInfo(i),
                style: _styles.lightText(
                  14.sp,
                  currentOption == i
                      ? Customization.variable_4
                      : const Color(0xFF2F2F2F),
                ),
                textAlign: TextAlign.center,
                textScaleFactor: 1.0,
              ),
            ],
          ),
        ),
      );
  }

  void tabAnalytics(int i) {
    final tab = {
      0: 'tab_pagos_pendientes',
      1: 'tab_pagos_realizados',
      2: 'tab_pagos_detalle',
    };
    Analytics().addEventUserProject(name: tab[i] ?? '', context: context);
  }

  paymentInfo(int i) {
    List<String> paymentInfo = [
      "payments.pending_payments_tag".i18n,
      "payments.payments_made_tag".i18n,
      "payments.purchase_detail_tag".i18n
    ];
    return paymentInfo[i];
  }
}
