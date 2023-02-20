import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'package:iclavis/blocs/property/property_bloc.dart';

import 'styles.dart';

final _styles = DrawerPropertyStyles();

class PropertyLocation extends StatelessWidget {
  const PropertyLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final property =
        (context.watch<PropertyBloc>().state as PropertySuccess).result.data;

    return Container(
      width: 328.w,
      padding: EdgeInsets.only(
        top: 10.h,
        left: 6.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(FlutterI18n.translate(context, "my_properties.location_title"),
            style: _styles.mediumText(14.sp, const Color(0xff131212)),
          ),
          Container(
            padding: EdgeInsets.only(top: 3.h, bottom: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  size: 15.w,
                  textDirection: TextDirection.rtl,
                ),
                Expanded(
                  child: Text(
                    property.proyecto.direccion,
                    style: _styles.lightText(14.sp),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
