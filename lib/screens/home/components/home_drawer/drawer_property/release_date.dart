import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:iclavis/blocs/property/property_bloc.dart';
import 'package:iclavis/models/property_model.dart';

import 'styles.dart';

final _styles = DrawerPropertyStyles();

class ReleaseDate extends StatelessWidget {
  const ReleaseDate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PropertyModel property =
        (context.watch<PropertyBloc>().state as PropertySuccess).result.data;

    return Container(
      width: 328.w,
      padding: EdgeInsets.only(
        top: 15.h,
        left: 6.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AutoSizeText(
            property.proyecto?.nombre??'',
            style: _styles.mediumText(16.sp),
          ),
          AutoSizeText(
            property.negocios?.first.producto?.etapa?.nombre??'',
            style: _styles.lightText(14.sp),
          ),
        ],
      ),
    );
  }
}
