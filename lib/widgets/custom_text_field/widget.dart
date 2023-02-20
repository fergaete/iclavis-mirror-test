import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iclavis/personalizacion.dart';

import 'package:iclavis/shared/custom_icons.dart';

import 'styles.dart';

final _styles = CustomTextFieldStyles();

class CustomTextField extends StatefulWidget {
  final String attribute;
  final bool? expands;
  final String? hintText;
  final InputDecoration? decoration;
  final bool? obscureText;
  final double? height;
  final IconData? icon;
  final Color? iconBackgroundColor;
  final String? title;
  final EdgeInsets? margin;
  final dynamic onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ScrollController? scrollController;
  final TextInputType? keyboardType;
  final int? maxLength;
  final TextStyle? textStyle;
  final TextStyle? titleStyle;
  final FormFieldValidator<String>? validator;

  const CustomTextField({
    Key? key,
    required this.attribute,
    this.expands,
    this.hintText,
    this.decoration,
    this.icon,
    this.iconBackgroundColor,
    this.height,
    this.obscureText = false,
    this.title,
    this.margin,
    this.onChanged,
    this.controller,
    this.focusNode,
    this.scrollController,
    this.keyboardType,
    this.maxLength,
    this.textStyle,
    this.titleStyle,
    this.validator,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? value;
  bool? oscureText;

  @override
  void initState() {
    oscureText = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
        //  height: widget.height ?? 36.h,
          margin: widget.margin ??
              EdgeInsets.only(
                top: 3.5.h,
                bottom: 7.h,
              ),
          child: FormBuilderTextField(
            name: widget.attribute,
            maxLength: widget.maxLength,
            focusNode: widget.focusNode,
            validator: widget.validator,
            controller: widget.controller,
            scrollController: widget.scrollController,
            obscureText: oscureText ?? false,
            maxLines: widget.expands != null ? null : 1,
            cursorColor: Customization.variable_7,
            keyboardType: widget.keyboardType,
            style: widget.textStyle
                ?.copyWith(color: Customization.variable_7),
            decoration: widget.decoration ??
                _styles.textFieldDecoration(Customization.variable_7).copyWith(
                  errorStyle: const TextStyle(
                    color: Colors.grey
                  ),
                      hintText: widget.hintText ?? "",
                      hintStyle: _styles.lightText(
                        12.sp,
                        Customization.variable_7,
                      ),
                      counterText: '',
                      contentPadding: EdgeInsets.only(
                        top: 10.h,
                        left: 10.w,
                      ),
                      prefixIcon: widget.icon != null
                          ? Container(
                              margin: EdgeInsets.only(
                                left: 1.w,
                                top: 1.h,
                                bottom: 1.h,
                                right: 5.w,
                              ),
                              decoration: _styles
                                  .boxDecoration(Customization.variable_6),
                              child: Icon(
                                widget.icon,
                                color: Customization.variable_7,
                                size: 19.94.sp,
                              ),
                            )
                          : null,
                      suffixIcon: widget.obscureText == true
                          ? IconButton(
                              icon: Icon(
                                oscureText == true
                                    ? CustomIcons.i_ingresar_contrasen_a
                                    : CustomIcons.i_confirmar_contrasen_a,
                              ),
                              iconSize: 16.5.sp,
                              padding: EdgeInsets.zero,
                              color:
                                  Customization.variable_7,
                              onPressed: () {
                                if (oscureText == true) {
                                  setState(() => oscureText = false);
                                } else {
                                  setState(() => oscureText = true);
                                }
                              },
                            )
                          : null,
                    ),
            onChanged: widget.onChanged,
          ),
        ),
      ],
    );
  }
}
