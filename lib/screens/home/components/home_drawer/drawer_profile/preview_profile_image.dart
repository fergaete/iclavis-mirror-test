import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/shared/custom_icons.dart';

import 'profile_bottom_sheet.dart';
import 'styles.dart';
import '../drawer_app_bar.dart';

final _styles = DrawerProfileStyles();

class PreviewProfileImage extends StatefulWidget {
  final String fullname;

  const PreviewProfileImage({
    Key? key,
    required this.fullname,
  }) : super(key: key);

  @override
  _PreviewProfileImageState createState() => _PreviewProfileImageState();
}

class _PreviewProfileImageState extends State<PreviewProfileImage> {
  late XFile pathImage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const ProfileAppBar(title: "Perfil"),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 29.h,
              child: Container(
                width: 197.w,
                height: 197.w,
                decoration: _styles.profileImageDecoration(
                  defaultImage: "assets/images/default_profile_image.png",
                ),
              ),
            ),
            Positioned(
              top: 160.h,
              left: 233.w,
              child: Container(
                decoration: _styles.iconDecoration,
                child: GestureDetector(
                    child: Icon(
                      CustomIcons.i_camara_foto,
                      size: 46.w,
                      color: Colors.white,
                    ),
                    onTap: () => openBottomSheet(context)),
              ),
            ),
            Positioned(
              top: 273.h,
              child: Text(
                widget.fullname,
                style: _styles.lightText(24.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openBottomSheet(BuildContext context) => showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (_) => ProfileBottomSheet(
          onTap: (v) => pickImage(context, v),
        ),
      );

  void pickImage(BuildContext context, ImageSource imageSource) async {
    Navigator.pop(context);

    XFile? pickedFile = await ImagePicker().pickImage(
      source: imageSource,
    );

    if (pickedFile != null) {
      setState(() {
        pathImage = pickedFile;
      });
    }
  }
}
