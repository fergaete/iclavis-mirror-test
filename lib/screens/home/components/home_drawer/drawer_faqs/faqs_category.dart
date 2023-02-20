import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/models/faq_model.dart';
import 'package:iclavis/shared/custom_newicons.dart';
import 'package:iclavis/widgets/widgets.dart';

import 'faq.dart';
import 'styles.dart';


class FaqsCategory extends StatelessWidget {
  final FaqModel faq;

  const FaqsCategory({super.key, required this.faq});

  @override
  Widget build(BuildContext context) {
    return ExpansionCard(
      leading: Icon(iconByTye(faq.detalle),
        size: 35.h,
        color: const Color(0xff2F2F2F),
      ),
      title:
        faq.detalle,
      icon: true,
      child: Column(
       children:
          List.generate(
              faq.preguntasFrecuentes.length,
                  (i) => Faq(
                question: faq.preguntasFrecuentes[i].glosa??'',
                answer: faq.preguntasFrecuentes[i].respuesta??'',
                isListEnd: faq.preguntasFrecuentes.length == i ? true : false,
              ))
      ),
    );
  }

  IconData iconByTye(String? type) {
    final iconList={
      'Proceso de compra':CustomNewIcon.procesoCompra,
      'Financiamiento':CustomNewIcon.financiamiento,
      'Postventa':CustomNewIcon.postVenta,
      'Entrega':CustomNewIcon.iconFile,
      'Otros':CustomNewIcon.otros,
    };
    return iconList[type] ?? CustomNewIcon.otros;

  }
}
