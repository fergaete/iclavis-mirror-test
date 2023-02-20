import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iclavis/models/user_support_type_warranty.dart';

import '../styles.dart';

final _styles = UserSupportViewsStyles();

class WarrantyStatus extends StatelessWidget {
  final UserSupportTypeWarranty? _typeWarranty;
  const WarrantyStatus(this._typeWarranty, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          FlutterI18n.translate(context, "form.Postventa_Estado_Garantía"),
          style: _styles.lightText(14.sp),
        ),
        StatusRequest(_typeWarranty?.estado ?? 'NO DEFINIDA', 1),
      ],
    );
  }
}

class WarrantyType extends StatelessWidget {
  final UserSupportTypeWarranty? _typeWarranty;
  const WarrantyType(this._typeWarranty, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          FlutterI18n.translate(context, "form.Postventa_Tipo_Garantía"),
          style: _styles.lightText(14.sp),
        ),
        StatusRequest(_typeWarranty?.nombre ?? 'NO DEFINIDA', 0),
      ],
    );
  }
}

class StatusRequest extends StatelessWidget {
  final String title;
  final int? status;

  const StatusRequest(this.title, this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 5.w,
      ),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: status == 1 ? typeColorByTitle(title, 'bg') : const Color(0xffd8d8d8),
      ),
      child: Row(
        children: [
          Text(title.trim() == "" ? "NO DEFINIDA" : title,
              style: _styles.regularText(12.sp).copyWith(
                    color: status == 1
                        ? typeColorByTitle(title, 'color')
                        : const Color(0xff777777),
                  ))
        ],
      ),
    );
  }

  Color typeColorByTitle(String type, String color) {
    const colorList = {
      'NO DEFINIDA': {
        'color': Color(0xff777777),
        'bg': Color(0xffd8d8d8),
      },
      'NO DEFINIDO': {
        'color': Color(0xff777777),
        'bg': Color(0xffd8d8d8),
      },
      'POR VALIDAR': {
        'color': Color(0xffFFBF41),
        'bg': Color(0xfffff8e6),
      },
      'VIGENTE': {
        'color': Color(0xff47BC4C),
        'bg': Color(0xffcfffd1),
      },
      'VENCIDA': {
        'color': Color(0xffFF0018),
        'bg': Color(0xffffe6e6),
      },
    };

    return colorList[type]?[color] ?? const Color(0xffd8d8d8);
  }
}
