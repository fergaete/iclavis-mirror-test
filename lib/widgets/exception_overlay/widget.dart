import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/shared/textstyles_shared.dart';

final _styles = TextStylesShared();

class ExceptionOverlay {
  final BuildContext context;
  final String message;
  final String? buttonTitle;
  final double? buttonTitleSize;
  final IconData? icon;
  final Color? iconColor;
  final Duration? duration;

  OverlayEntry? overlay;

  ExceptionOverlay({
    required this.context,
    required this.message,
    this.buttonTitle,
    this.buttonTitleSize,
    this.icon,
    this.iconColor,
    this.duration,
  }) : assert(
          icon == null && iconColor == null ||
              icon != null && iconColor != null,
        ) {
    overlay = OverlayEntry(
      builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 308.w,
            height: 54.h,
            margin: EdgeInsets.only(bottom: 6.h),
            child: Card(
              elevation: 3,
              color: Color(0xff2F2F2F),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.w)),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: icon != null ? 12.w : 15.w),
                child: Center(
                  child: Row(
                    mainAxisAlignment: buttonTitle != null
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 270.w,
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: _styles.regularText(14.sp, Colors.white),
                          maxLines: 3,
                        ),
                      ),
                      Visibility(
                        visible: icon != null,
                        child: Icon(
                          icon,
                          color: iconColor ?? Colors.white,
                        ),
                      ),
                      Visibility(
                        visible: buttonTitle != null,
                        child: InkWell(
                          child: Text(
                            buttonTitle ?? '',
                            style: _styles.mediumText(
                                buttonTitleSize ?? 12.sp, Colors.white),
                          ),
                          onTap: () => overlay?.remove(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );

    buildOverlay(context);
  }

  void buildOverlay(BuildContext context) {
    Overlay.of(context)?.insert(overlay!);

    if (buttonTitle == null) {
      Future.delayed(duration ?? Duration(seconds: 4))
          .then((value) => overlay?.remove());
    }
  }
}
