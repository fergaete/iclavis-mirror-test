import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/shared/custom_icons.dart';

import 'option_button.dart';
import 'styles.dart';

final _styles = DrawerProfileStyles();

typedef void _VoidWithArg(ImageSource e);

class ProfileBottomSheet extends StatelessWidget {
  final _VoidWithArg? onTap;

  const ProfileBottomSheet({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String i18n(String text) => FlutterI18n.translate(context, text);
    return SizedBox(
      height: 228.h,
      child: Card(
        margin: EdgeInsets.zero,
        color: Colors.white,
        shape: _styles.bottomSheetShape,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: 65.h,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: 24.h,
                  left: 24.w,
                  bottom: 10.h,
                ),
                child: Text(i18n("profile.change_picture"), style: _styles.mediumText(16.sp)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  OptionButton(
                    label: i18n("profile.delete"),
                    icon: CustomIcons.i_eliminar,
                  ),
                  OptionButton(
                    label: i18n("profile.gallery"),
                    icon: CustomIcons.i_galeria,
                    onTap: () => onTap!(
                      ImageSource.gallery,
                    ),
                  ),
                  OptionButton(
                    label: i18n("profile.camera"),
                    icon: CustomIcons.i_camara,
                    onTap: () => onTap!(
                      ImageSource.camera,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
