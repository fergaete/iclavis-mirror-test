import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'package:iclavis/models/user_model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'styles.dart';
import 'user_property.dart';

final _styles = DrawerProfileStyles();

class ProfileInfo extends StatelessWidget {
  final UserModel user;

  final GlobalKey<FormBuilderState> formBuilderKey;

  const ProfileInfo({
    Key? key,
    required this.formBuilderKey,
    required this.user,
  }) : super(key: key);

  final int i = 0;
  final String deleteAccountUrl="https://www.planok.com/borrar-cuenta/";

  @override
  Widget build(BuildContext context) {
    String i18n(String text) => FlutterI18n.translate(context, text);
    return Expanded(
      child: FormBuilder(
        key: formBuilderKey,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            return true;
          },
          child: Container(
            height: 200,
            child: ListView(
              physics: const ClampingScrollPhysics(),
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 20.h,
                    ),
                    child: Text(i18n("profile.personal_information"),
                      style: _styles.lightText(16.sp),
                    ),
                  ),
                ),
                UserProperty(
                  title: i18n("profile.id_number"),
                  value: user.dni ?? '',
                  visible: true,
                ),
                UserProperty(
                  title:i18n("profile.date_birth") ,
                  value: user.fechaNacimiento ?? i18n("profile.no_data"),
                  visible: true,
                ),
                UserProperty(
                  title: i18n("profile.nationality"),
                  value: user.nacionalidad ?? '',
                  visible: true,
                ),
                UserProperty(
                  title: i18n("profile.phone_number"),
                  value: user.fono ?? '',
                  visible: true,
                ),
                UserProperty(
                  title: i18n("profile.email"),
                  value: user.email ?? '',
                  visible: true,
                ),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 20.h,
                    ),
                    child: Text(
                      i18n("profile.adress"),
                      style: _styles.lightText(16.sp),
                    ),
                  ),
                ),
                UserProperty(
                  title: i18n("profile.street"),
                  value:
                      "${user.calle ?? ''} ${user.numero ?? ''} ${user.depto ?? ''}",
                  visible: true,
                ),
                UserProperty(
                  title: i18n("profile.city"),
                  value: user.comuna ?? '',
                  visible: true,
                ),
                UserProperty(
                  title: i18n("profile.province"),
                  value: user.provincia ?? '',
                  visible: true,
                ),
                UserProperty(
                  title: i18n("profile.region"),
                  value: user.region ?? '',
                  visible: true,
                ),
                if(Platform.isIOS)
                Column(
                  children: [
                    const Divider(height: 1,),
                    const SizedBox(height: 30,),
                    InkWell(
                      onTap: ()=>launchPage(deleteAccountUrl),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        child: Text(i18n("profile.delete_account"),
                        textAlign: TextAlign.center,),
                      )
                    ),
                    const SizedBox(height: 20,),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future launchPage(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }
}
