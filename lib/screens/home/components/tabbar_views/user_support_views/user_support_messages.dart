import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/personalizacion.dart';
import 'package:iclavis/screens/home/components/home_drawer/drawer_faqs/drawer_faqs.dart';

import 'styles.dart';

final _styles = UserSupportViewsStyles();

class UserSupportMessages extends StatelessWidget {
  final String message;

  const UserSupportMessages({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 6,
          child: Container(
            width: 325.w,
            padding: EdgeInsets.fromLTRB(20.w, 10.h, 15.w, 25.h),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/alert_contact_form.png',
                  width: 40.w,
                ),
                SizedBox(
                  height: 10.w,
                ),
                Text(
                  (message == null || message == "")
                      ? 'Cualquier duda o consulta debe '
                          'contactarse directamente con su '
                          'ejecutivo de ventas o enviar un correo a '
                          'inmobiliaria@ejemplo.cl'
                          '\n\n'
                          'Recuerde que tenemos una sección con '
                          'tips para su compra, que lo ayudarán a '
                          'orientarse en el proceso de compra.'
                      : message,
                  style: _styles.regularText(14.sp),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 30.h,
        ),
        Card(
          elevation: 6,
          child: Container(
            width: 335.w,
            padding: EdgeInsets.fromLTRB(8.w, 15.h, 0, 20.h),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/tips_para_compra.png',
                  width: 65.w,
                  height: 100.h,
                ),
                SizedBox(
                  width: 5.w,
                ),
                SizedBox(
                  width: 240.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tips para tu compra',
                        style: _styles.boldText(16.sp),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      SizedBox(
                        width: 215.w,
                        child: Text(
                          'Revisa las típicas dudas que todo propietario'
                          ' suele tener al comprar una nueva vivienda.',
                          style: _styles.regularText(14.sp),
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          child: Text(
                            'Ver más',
                            style: _styles.boldText(
                                14.sp, Customization.variable_1),
                          ),
                          onTap: () => Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (c, _, __) {
                                return DrawerFaqs();
                              },
                              transitionDuration: Duration(seconds: 0),
                              fullscreenDialog: true,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
