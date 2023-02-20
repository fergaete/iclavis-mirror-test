import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/shared/textstyles_shared.dart';
import 'package:iclavis/widgets/widgets.dart';

final _styles = TextStylesShared();

class ModalOverlay {
  final BuildContext context;
  final String title;
  final String message;
  final String buttonTitle;
  final Color? backgroundColor;
  final Color? colorAllText;
  final VoidCallback? onPressed;

  OverlayEntry? overlayBackground;
  OverlayEntry? overlay;

  /// if backgroundColor != null, the tips are activated
   ModalOverlay({
    required this.context,
    required this.title,
    required this.message,
    required this.buttonTitle,
    this.backgroundColor,
    this.colorAllText,
     this.onPressed
  }) {
    overlayBackground = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 0,
            sigmaY: 0,
          ),
          child: Container(
            color: Color(0xff4D4D4D).withOpacity(0.44),
          ),
        ),
      ),
    );

    overlay = OverlayEntry(
      builder: (context) => Container(
        color: backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 290.w,
              child: Card(
                margin: EdgeInsets.zero,
                elevation: 0,
                color:
                    backgroundColor != null ? Colors.transparent : Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.w)),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 29.h),
                  child: Column(
                    children: [
                      Text(
                        title,
                        style: _styles.mediumText(
                            40.sp, colorAllText ?? Color(0xff1A2341)),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 17.w),
                        margin: EdgeInsets.only(top: 34.h, bottom: 21.h),
                        child: Text(
                          FlutterI18n.translate(context, message),
                          textAlign: TextAlign.left,
                          style: _styles.regularText(
                              16.sp, colorAllText ?? Color(0xff1A2341)),
                        ),
                      ),
                      SizedBox(
                        width: 174.w,
                        height: 36.h,
                        child: ActionButton(
                          label: buttonTitle,
                          buttonTitleColor: colorAllText,
                          isEnabled: true,
                          onPressed:onPressed==null? () {
                            if (backgroundColor == null) {
                              overlayBackground?.remove();
                              overlay?.remove();
                            } else {
                              overlay?.remove();
                              TipsOverlay.remove();
                            }
                          }:(){
                            onPressed!();
                            if (backgroundColor == null) {
                              overlayBackground?.remove();
                              overlay?.remove();
                            } else {
                              overlay?.remove();
                              TipsOverlay.remove();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );

    _buildOverlay();
  }

  void _buildOverlay() {
    if (backgroundColor == null) {
      Overlay.of(context)?.insertAll([overlayBackground!, overlay!]);
    } else {
      Overlay.of(context)?.insert(overlay!);
      TipsOverlay.show(context);
    }
  }
}
