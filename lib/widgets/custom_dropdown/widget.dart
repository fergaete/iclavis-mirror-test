import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'styles.dart';

final _styles = CustomDropdownStyles();

typedef void VoidOnChanged(String v);

class CustomDropdown extends StatelessWidget {
  final String attribute;
  final String? label;
  final String? initialValue;
  final List<String> data;
  final VoidOnChanged? onChanged;

  const CustomDropdown({super.key,
    required this.attribute,
    required this.data,
    this.label,
    this.initialValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Visibility(
          visible: label != null ? true : false,
          child: Container(
            margin: EdgeInsets.only(
              bottom: 3.5.h,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              label ?? '',
              style: _styles.mediumText(12.sp, const Color(0xff463E40)),
            ),
          ),
        ),
        Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                bottom: 7.h,
              ),
              height: 36.h,
              child: FormBuilderDropdown(
                name: attribute,
                decoration: _styles.dropdownDecoration,
                items: data
                    .map(
                      (building) => DropdownMenuItem(
                        value: building,
                        child: Text(building),
                      ),
                    )
                    .toList(),
                onChanged: (v) => onChanged!(v!),
              ),
            ),
            Container(
              height: 34.h,
              width: 37.w,
              margin: EdgeInsets.only(
                left: 1.w,
                top: 1.h,
                bottom: 1.h,
                right: 5.w,
              ),
              decoration: _styles.boxDecoration,
              child: Icon(
                Icons.lock_outline,
                color: const Color(0xffc8c6c6),
                size: 19.94.w,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
