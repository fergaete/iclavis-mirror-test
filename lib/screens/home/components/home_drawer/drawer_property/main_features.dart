import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:charcode/charcode.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:iclavis/blocs/property/property_bloc.dart';
import 'package:iclavis/models/property_model.dart';
import 'package:iclavis/shared/shared.dart';
import 'package:iclavis/widgets/widgets.dart';

import 'feature.dart';
import 'styles.dart';

final _styles = DrawerPropertyStyles();

_ascii(int code) => String.fromCharCodes([code]);

class MainFeatures extends StatelessWidget {
  const MainFeatures({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PropertyModel property =
        (context.watch<PropertyBloc>().state as PropertySuccess).result.data;
    String i18n(String text) => FlutterI18n.translate(context, text);

    final index = property.negocios?.indexWhere((p) => p.isCurrent!);

    final currentPropertyIndex = index!.isNegative ? 0 : index;

    return Container(
      width: 328.w,
      padding: EdgeInsets.only(top: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            i18n("my_properties.main_features_title"),
            style: _styles.mediumText(14.sp, Color(0xff131212)),
          ),
          Feature(
              icon: CustomIcons.i_habiatciones,
              feature: i18n("my_properties.bedrooms"),
              value: property.negocios![currentPropertyIndex].producto!.modelo!.cantDormitorios!.toString()),
          Feature(
              icon: CustomIcons.i_ban_os,
              feature: i18n("my_properties.bathrooms"),
              value: property
                  .negocios![currentPropertyIndex].producto!.modelo!.cantBanos!
                  .toString()),
          if (property.negocios![currentPropertyIndex].productosSecundarios!
              .where((p) => p.tipo!.toLowerCase() == 'estacionamiento').isNotEmpty)
            Feature(
                icon: CustomIcons.i_estacionamiento,
                feature: i18n("my_properties.parking"),
                value: property
                    .negocios![currentPropertyIndex].productosSecundarios
                    !.where((p) => p.tipo!.toLowerCase() == 'estacionamiento')
                    .map((e) => e.nombre)
                    .join(', ')
                    .isSecondaryProductEmpty),
          if (property.negocios![currentPropertyIndex].productosSecundarios
              !.where((p) => p.tipo!.toLowerCase() == 'bodega').isNotEmpty)
            Feature(
                icon: CustomIcons.i_bodega,
                feature: i18n("my_properties.storage"),
                value: property
                    .negocios![currentPropertyIndex].productosSecundarios!
                    .where((p) => p.tipo!.toLowerCase() == 'bodega')
                    .map((e) => e.nombre)
                    .join(', ')
                    .isSecondaryProductEmpty),
          if (property.negocios![currentPropertyIndex].producto!.orientacion !=
                  null &&
              property.negocios![currentPropertyIndex].producto!.orientacion !=
                  "")
            Feature(
                icon: CustomIcons.i_orientacion,
                feature: i18n("my_properties.orientation"),
                value: property
                    .negocios?[currentPropertyIndex].producto?.orientacion ??''),
          Padding(
            padding: EdgeInsets.only(top: 35.h),
            child: Text(
              i18n("my_properties.footage"),
              style: _styles.mediumText(14.sp, Color(0xff131212)),
            ),
          ),
          if (property
                  .negocios?[currentPropertyIndex].producto!.modelo!.supTotal !=
              0)
            Padding(
              padding: EdgeInsets.only(
                top: 14.h,
                bottom: 5.h,
              ),
              child: Text(
                "${i18n("my_properties.total_footage")} ${property.negocios?[currentPropertyIndex].producto!.modelo!.supTotal} m${_ascii($sup2)}",
                style: _styles.lightText(14.sp),
              ),
            ),
          if (property.negocios?[currentPropertyIndex].producto!.modelo!.supUtil !=
              0)
            Padding(
              padding: EdgeInsets.only(
                bottom: 5.h,
              ),
              child: Text(
                "${i18n("my_properties.inside_footage")} ${property.negocios?[currentPropertyIndex].producto!.modelo!.supUtil} m${_ascii($sup2)}",
                style: _styles.lightText(14.sp),
              ),
            ),
          if (property
                  .negocios?[currentPropertyIndex].producto!.modelo!.supTerraza !=
              0)
            Padding(
              padding: EdgeInsets.only(
                bottom: 30.h,
              ),
              child: Text(
                "${i18n("my_properties.terrace_footage")} ${property.negocios?[currentPropertyIndex].producto!.modelo!.supTerraza} m${_ascii($sup2)}",
                style: _styles.lightText(14.sp),
              ),
            ),
          if (property
                  .negocios?[currentPropertyIndex].producto!.modelo!.supInterior !=
              0)
            Padding(
              padding: EdgeInsets.only(
                bottom: 30.h,
              ),
              child: Text(
                "Superficie interior ${property.negocios?[currentPropertyIndex].producto!.modelo!.supInterior} m${_ascii($sup2)}",
                style: _styles.lightText(14.sp),
              ),
            ),
          if (property
                  .negocios?[currentPropertyIndex].producto!.modelo!.supPalier !=
              0)
            Padding(
              padding: EdgeInsets.only(
                bottom: 30.h,
              ),
              child: Text(
                "Superficie palier ${property.negocios?[currentPropertyIndex].producto!.modelo!.supPalier} m${_ascii($sup2)}",
                style: _styles.lightText(14.sp),
              ),
            ),
          if (property
                  .negocios?[currentPropertyIndex].producto!.modelo!.supLoggia !=
              0)
            Padding(
              padding: EdgeInsets.only(
                bottom: 30.h,
              ),
              child: Text(
                "Superficie logia ${property.negocios?[currentPropertyIndex].producto?.modelo?.supLoggia} m${_ascii($sup2)}",
                style: _styles.lightText(14.sp),
              ),
            ),
          if (property.negocios![currentPropertyIndex].producto!.modelo!
                  .supMunicipal !=
              0)
            Padding(
              padding: EdgeInsets.only(
                bottom: 30.h,
              ),
              child: Text(
                "Superficie municipal ${property.negocios?[currentPropertyIndex].producto?.modelo?.supMunicipal} m${_ascii($sup2)}",
                style: _styles.lightText(14.sp),
              ),
            ),
          SizedBox(
            height: 5.h,
          ),
          Center(
            child: GestureDetector(
                onTap: () => {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) {
                          return FullScreenImage(
                              imgUrl:property
                                  .negocios?[currentPropertyIndex].producto?.modelo?.plano1??'',
                              title: 'Planos');
                        },
                      ))
                    },
                child: Container(
                  width: 260.w,
                  height: 206.h,
                  decoration: _styles.blueprintDecoration,
                  child: CachedNetworkImage(
                    imageUrl: property
                        .negocios?[currentPropertyIndex].producto?.modelo?.plano1??'',
                    fit: BoxFit.contain,
                    errorWidget: (_, url, __) {
                      return EmptyImage(
                        innerPadding: 26.h,
                      );
                    },
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

extension IsSecondaryProductEmpty on String {
  String get isSecondaryProductEmpty => this.isEmpty ? '-' : this;
}
