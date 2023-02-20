import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:iclavis/blocs/property/property_bloc.dart';
import 'package:iclavis/models/property_model.dart';
import 'package:iclavis/shared/shared.dart';
import 'package:iclavis/utils/Translation/name_utils.dart';

import 'styles.dart';

final _styles = DrawerPropertyStyles();

class PropertiesSlider extends StatefulWidget {
  const PropertiesSlider({Key? key}) : super(key: key);

  @override
  PropertiesSliderState createState() => PropertiesSliderState();
}

class PropertiesSliderState extends State<PropertiesSlider> {
  late ScrollController _controller;
  late int currentPropertyIndex;

  late PropertyModel property;

  List<LabeledGlobalKey> keys = [];

  @override
  void initState() {
    _controller = ScrollController();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    property =
        (context.read<PropertyBloc>().state as PropertySuccess).result.data;

    final index = property.negocios!.indexWhere((p) => p.isCurrent!);

    currentPropertyIndex = index.isNegative ? 0 : index;

    property.negocios?.forEach((e) => keys.add(LabeledGlobalKey("${e.idGci}")));

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
          property.negocios?.length??0,
          (i) => GestureDetector(
            child: Card(
              key: keys[i],
              elevation: 1.h,
              color:
                  i == currentPropertyIndex ? Color(0xffe9e4dc) : Colors.white,
              shape: _styles.slideBorder,
              margin: EdgeInsets.only(
                top: 4.h,
                bottom: 4.h,
                left: 4.w,
                right: 20.w,
              ),
              child: Container(
                width: 184.w,
                height: 66.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          property.negocios?[i].producto?.tipo ?? '',
                          style: _styles.lightText(14.sp, Color(0xff2f2f2f)),
                          textScaleFactor: 1.0,
                        ),
                        Icon(
                          CustomIcons.i_departamento,
                          size: 18.h,
                        ),
                      ],
                    ),
                    Text(NameUtil.shortName(property.negocios?[i].producto?.nombre??''),
                      style: _styles.mediumText(14.sp),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            onTap: () async {
              setState(() => currentPropertyIndex = i);
              context.read<PropertyBloc>().add(
                    CurrentPropertySaved(
                        id: property.negocios![currentPropertyIndex].producto!.idGci!),
                  );

              final RenderObject rb = keys[i].currentContext!.findRenderObject()!;

              await _controller.position.ensureVisible(
                rb,
                alignment: 0.58,
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
              );
            },
          ),
        ),
      ),
    );
  }
}
