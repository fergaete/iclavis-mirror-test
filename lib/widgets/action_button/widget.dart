import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iclavis/personalizacion.dart';

import 'styles.dart';

final _styles = ActionButtonStyles();

class ActionButton extends StatelessWidget {
  final String label;
  final TextStyle? labelStyle;
  final OutlinedBorder? shape;
  final VoidCallback onPressed;
  final bool isEnabled;
  final Color? buttonTitleColor;

  const ActionButton({
    required this.label,
    required this.onPressed,
    this.labelStyle,
    this.isEnabled = false,
    this.shape,
    this.buttonTitleColor,
    key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(0),
            backgroundColor: isEnabled? Customization.variable_1
            : Customization.variable_1.withOpacity(.4),
            shape:shape ?? _styles.shape,
          ),
        onPressed: onPressed,
        child: Text(
          label,
          style: labelStyle ??
              _styles.mediumText(
                16.sp,
                Customization.variable_3,
              ),
        ),
      ),
    );
  }
}
