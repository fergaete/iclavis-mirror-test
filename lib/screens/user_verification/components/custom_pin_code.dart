import 'package:flutter/material.dart';
import 'package:iclavis/personalizacion.dart';

import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'styles.dart';

final _styles = UserVerificationStyles();

class CustomPinCode extends StatelessWidget {
  final Function onChanged;

  const CustomPinCode({required this.onChanged, key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      length: 6,
      obscureText: false,
      autoDismissKeyboard: false,
      backgroundColor: Colors.transparent,
      pinTheme: PinTheme(
        inactiveColor: Customization.variable_7,
        activeColor: Customization.variable_7,
        selectedColor: Customization.variable_7,
        borderWidth: 1,
        borderRadius: _styles.borderRadiusPinCode,
        shape: PinCodeFieldShape.box,
        fieldHeight: 33.73.w,
        fieldWidth: 31.67.w,
      ),
      textStyle: _styles.mediumText(12.sp, Customization.variable_7),
      keyboardType: TextInputType.number,
      animationType: AnimationType.fade,
      animationDuration: Duration(milliseconds: 300),

      onChanged: (v) => onChanged(v), appContext: context,
    );
  }
}
