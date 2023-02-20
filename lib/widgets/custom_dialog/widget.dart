import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'styles.dart';
import '../action_button/widget.dart';

final _styles = CustomDialogStyles();

class CustomDialog extends StatelessWidget {
  final String? title, description, buttonText;
  final double? height, width, widthButton;
  final Widget? icon;
  final VoidCallback? onPressed;

  CustomDialog({super.key,
    required this.height,
    this.width,
    this.title,
    this.description,
    this.buttonText,
    this.icon,
    this.onPressed,
    this.widthButton,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: _styles.dialogShape,
      insetPadding: width == null
          ? EdgeInsets.symmetric(horizontal: 40.w)
          : EdgeInsets.symmetric(horizontal: (360.w - width!) / 2),
      child: SizedBox(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 9.h,
              right: 13.w,
              child: GestureDetector(
                child: Icon(
                  Icons.close,
                  size: 16.w,
                  color: Colors.black.withOpacity(.54),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Column(
              children: <Widget>[
                Visibility(
                  visible: title != null ? true : false,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(
                      top: 36.h,
                      left: 24.h,
                    ),
                    child: Text(
                      title ?? '',
                      style: _styles.boldText(18.sp, const Color(0xff463E40)),
                    ),
                  ),
                ),
                Visibility(
                  visible: icon != null ? true : false,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 24.h,
                    ),
                    child: Center(
                      child: icon,
                    ),
                  ),
                ),
                Padding(
                  padding: icon == null
                      ? EdgeInsets.only(
                          left: 24.h,
                          right: 24.h,
                        )
                      : EdgeInsets.only(
                          top: 12.h,
                        ),
                  child: Text(
                    description??'',
                    textAlign: TextAlign.left,
                    style: _styles.regularText(14.sp, Color(0xff463E40)),
                  ),
                ),
                Visibility(
                  visible: widthButton != null ? true : false,
                  child: Container(
                    width: widthButton,
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.only(
                      top: 20.h,
                    ),
                    child: ActionButton(
                      label: buttonText??'',
                      labelStyle: _styles.regularText(16.sp, Colors.white),
                      isEnabled: true,
                      onPressed: () => onPressed,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
