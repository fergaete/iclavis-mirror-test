import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/shared/textstyles_shared.dart';

import 'image_picker_button.dart';

final _styles = TextStylesShared();

class CustomImagePickerButtons extends StatelessWidget {
  final String label;
  final String maxSizeLabel;
  final List<String> buttons;
  final MainAxisAlignment align;

  const CustomImagePickerButtons({
    required this.buttons,
    required this.label,
    required this.maxSizeLabel,
    this.align = MainAxisAlignment.spaceBetween,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(
            top: 2.h,
            bottom: 3.5.h,
          ),
          child: Text(
            label,
            style: _styles.mediumText(12.sp, Color(0xff463E40)),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            bottom: 4.h,
          ),
          child: Row(
            mainAxisAlignment: align,
            children: buttons
                .map(
                  (v) => ImagePickerButton(
                    attribute: v,
                  ),
                )
                .toList(),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            maxSizeLabel,
            style: _styles.mediumText(12.sp, Color(0xff999595)),
          ),
        ),
      ],
    );
  }
}



