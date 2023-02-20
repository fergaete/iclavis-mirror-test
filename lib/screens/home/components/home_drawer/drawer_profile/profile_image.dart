import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/models/user_model.dart';

import 'preview_profile_image.dart';
import 'styles.dart';

final _styles = DrawerProfileStyles();

class ProfileImage extends StatelessWidget {
  final UserModel user;

  const ProfileImage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        top: 21.h,
        bottom: 46.h,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap:null,
            child: Container(
              width: 83.w,
              height: 83.w,
              margin: EdgeInsets.only(bottom: 20.h),
              decoration: _styles.profileImageDecoration(
                defaultImage:"assets/images/default_profile_image.png",
              ),
            )//openSelectProfileImage(context),
          ),
          Text(
            "${user.nombre} ${user.apellidoPaterno} ${user.apellidoMaterno}",
            style: _styles.lightText(24.sp),
          )
        ],
      ),
    );
  }

  void openSelectProfileImage(BuildContext context) =>
      Navigator.of(context).push(
        MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return PreviewProfileImage(
              fullname:
                  "${user.nombre} ${user.apellidoPaterno} ${user.apellidoMaterno}",
            );
          },
          fullscreenDialog: true,
        ),
      );
}
