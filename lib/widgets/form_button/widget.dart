import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iclavis/personalizacion.dart';


import '../action_button/styles.dart';

final _styles = ActionButtonStyles();
class FormButton extends StatelessWidget {
  final String label;
  final TextStyle? labelStyle;
  final ShapeBorder? shape;
  final VoidCallback onPressed;
  final bool isEnabled;
  final Color? buttonTitleColor;

  const FormButton({
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
        style:  ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0),
          backgroundColor: isEnabled
              ? Customization.variable_1
              : Colors.white,
         /* overlayColor: isEnabled
              ?  MaterialStateProperty.all(Customization.variable_1)
              :  MaterialStateProperty.all(Colors.red),*/
          shape:   RoundedRectangleBorder(
        side: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.all(
          Radius.circular(
            4.h,
          ),
        ),
      ),
        ),
        onPressed: isEnabled?onPressed:(){},

        child: Text(
          label,
          style:
              _styles.mediumText(
                16.sp,
                  isEnabled
                      ?Colors.white:Colors.grey,
              ),
          maxLines: 1,
          textScaleFactor: 1.0,
        ),
      ),
    );
  }
}
