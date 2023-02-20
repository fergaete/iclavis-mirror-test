import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'styles.dart';

final _styles = EmptyImageStyles();

class EmptyImage extends StatefulWidget {
  final double? innerPadding;

  const EmptyImage({Key? key, this.innerPadding}) : super(key: key);

  @override
  _EmptyImageState createState() => _EmptyImageState();
}

class _EmptyImageState extends State<EmptyImage> {
  double w = 86.w;
  double h = 77.h;

  String message = 'No se ha podido cargar la imagen';

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: _styles.emptyCardDecoration,
      margin: EdgeInsets.zero,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 180.w) {
                w = 57.w;
                h = 51.h;

                message = 'No se ha podido\ncargar la imagen';
              }

              return SvgPicture.asset(
                'assets/images/empty_image.svg',
                width: w,
                height: h,
              );
            },
          ),
          SizedBox(
            height: widget.innerPadding ?? 45.h,
          ),
          Text(
            message,
            style: _styles.lightText(12.sp, Color(0xff707070)),
            textAlign: TextAlign.center,
            textScaleFactor: 1.0,
          )
        ],
      ),
    );
  }
}
