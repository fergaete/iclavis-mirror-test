import 'package:flutter/material.dart';

import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'package:iclavis/blocs/property/property_bloc.dart';

import 'styles.dart';

final _styles = DrawerPropertyStyles();

class ProjectFeatures extends StatelessWidget {
  const ProjectFeatures({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final property =
        (context.watch<PropertyBloc>().state as PropertySuccess).result.data;

    return Container(
      width: 328.w,
      padding: EdgeInsets.only(top: 30.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(FlutterI18n.translate(context, "my_properties.project_features"),
            style: _styles.mediumText(14.sp, const Color(0xff131212)),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 16.h,
            ),
            child: Html(
              data: property.proyecto.descripcion ?? '',
              //defaultTextStyle: _styles.lightText(14.sp),
            ),
          ),
        ],
      ),
    );
  }
}
