import 'dart:ui';
import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/shared/textstyles_shared.dart';

final _styles = TextStylesShared();

abstract class TipsOverlay {
  static OverlayEntry _overlay(BuildContext context, String tip) =>
      OverlayEntry(
        builder: (context) => Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 318.w,
              constraints: BoxConstraints(minHeight: 103.h),
              margin: EdgeInsets.only(bottom: 21.h),
              child: Card(
                elevation: 3,
                margin: EdgeInsets.zero,
                color: Color(0xff999595),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.w)),
                child: Padding(
                  padding: EdgeInsets.only(left: 30.w, right: 30.w, top: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sabías qué…',
                        style: _styles.mediumText(18.sp, Colors.white),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        tip,
                        style: _styles.regularText(16.sp, Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  static OverlayEntry? _tipsOverlay;

  static bool _opened = false;

  static void show(BuildContext context) {
    Random random = Random();
    int randomTips;

    if (_opened) {
      return;
    } else {
      _opened = true;
    }

    randomTips = random.nextInt(_tips.length);

    _tipsOverlay = _overlay(context, _tips[randomTips]);

    Overlay.of(context)?.insert(_tipsOverlay!);

    Future.delayed(const Duration(seconds: 8)).then((_) {
      Timer.periodic(const Duration(seconds: 5), (Timer t) {
        if (!_opened) {
          t.cancel();
        }

        randomTips = random.nextInt(_tips.length);

        _tipsOverlay?.remove();

        _tipsOverlay = _overlay(context, _tips[randomTips]);

        Overlay.of(context)?.insert(_tipsOverlay!);
      });
    });
  }

  static void remove() {
    _opened = false;
    _tipsOverlay?.remove();
  }
}

const List<String> _tips = [
  'Las momias Chinchorros en Chile son las más antiguas del mundo.',
  'En Julio, Agosto y Septiembre florece el desierto de Atacama.',
  'La duna más alta del mundo es el Cerro Blanco ubicado en Perú.',
  'La palabra "Salario" viene del latín salarium, pago por sal.',
  'Sólo los insectos tienen tres pares de patas.',
  'La Luna tuvo un dueño, fue el Chileno Jenaro Gajardo Vera.',
  'Se llama Virgulilla a la tilde de la letra Ñ.',
  'El signo de división (%) se llama Óbelo.',
  'La tela de araña es el material más resistente de la naturaleza.',
  'El pastel de choclo es de origen peruano.',
  'El Salto Ángel es el más alto del mundo, ubicado en Venezuela.',
  'El "5" tiene el mismo número de letras que expresa: cinco.',
  'Caño Cristales es el río más hermoso de la tierra (Colombia).',
  'El Empire State fue el rascacielos más alto del mundo por 42 años.',
  '18 de los 25 hoteles más grandes del mundo están en las Vegas.',
  'La Gran Muralla china se demoró 2000 años en construirse.',
  'La casa más angosta mide 122 cm de ancho.',
  'La estatua de la libertad tiene un observatorio dentro de la antorcha.',
  'La arquitectura fue un deporte olímpico.',
  'El hotel más chico del mundo tiene 53 m2 (Alemania).',
];
