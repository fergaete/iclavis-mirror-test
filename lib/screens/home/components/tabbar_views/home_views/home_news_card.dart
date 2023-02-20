import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iclavis/personalizacion.dart';

import 'styles.dart';

final _styles = HomeViewsStyles();

class HomeNewsCard extends StatelessWidget {
  final String title, subtitle;
  final VoidCallback? onPressed;
  final String? asset;
  final IconData? icon;
  final VoidCallback? more;

  const HomeNewsCard(
      {Key? key,
      required this.title,
      required this.subtitle,
      this.onPressed,
      this.asset,
      this.icon,
      this.more})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.h,
      shadowColor: const Color(0xffdbdbdb),
      shape: _styles.newsCardBorder,
      child: Container(
          width: 340.w,
          padding:
              EdgeInsets.only(left: 10.w, right: 10.w, bottom: 20.w, top: 10.w),
          child: Row(
            children: [
              svgCustom(asset ?? 'assets/images/question_card.svg'),
              SizedBox(
                width: 5.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 200.w,
                          child: AutoSizeText(
                            title,
                            style: _styles.mediumText(15.sp),
                            maxLines: 1,
                          ),
                        ),
                        onPressed != null
                            ? SizedBox(
                                width: 30.w,
                                height: 30.w,
                                child: FloatingActionButton(
                                  heroTag: UniqueKey(),
                                  backgroundColor: Customization.variable_1,
                                  onPressed: onPressed,
                                  child: Icon(
                                    icon ?? Icons.add,
                                    size: 18.sp,
                                    color: Customization.variable_3,
                                  ),
                                ),
                              )
                            : SizedBox(
                                width: 30.w,
                                height: 30.w,
                              ),
                      ],
                    ),
                    Container(
                      width: 250.w,
                      margin: EdgeInsets.only(
                        top: 5.h,
                      ),
                      child: Text(
                        subtitle,
                        style: _styles.lightText(14.sp),
                      ),
                    ),
                    more != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: more,
                                  child: Text("Ver más",
                                      style: _styles.semiBoldText(
                                        14.sp,
                                        Customization.variable_1,
                                      )))
                            ],
                          )
                        : Container()
                  ],
                ),
              )
            ],
          )),
    );
  }

  Widget svgCustom(String asset) {
    return FutureBuilder<String>(
      future: stringTosvg(asset),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return SvgPicture.string(snapshot.data ?? '');
      },
    );
  }

  Future<String> stringTosvg(String asset) async {
    String svgString = await rootBundle.loadString(asset);

    if (Customization.personalizable) {
      svgString = svgString.replaceAll("#05cbc2",
          "#${HSLColor.fromColor(Customization.variable_1).withLightness(0.4).toColor().value.toRadixString(16).padLeft(6, '0').toUpperCase()}");
      svgString = svgString.replaceAll("#00a19a",
          "#${Customization.variable_1.value.toRadixString(16).padLeft(6, '0').toUpperCase()}");
      svgString = svgString.replaceAll("#01817c",
          "#${HSLColor.fromColor(Customization.variable_1).withLightness(0.3).toColor().value.toRadixString(16).padLeft(6, '0').toUpperCase()}");
    }

    return svgString;
  }
}
