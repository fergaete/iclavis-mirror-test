import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclavis/utils/Translation/translation_extension.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:iclavis/blocs/contacts/contacts_bloc.dart';
import 'package:iclavis/models/contacts_model.dart';
import 'package:iclavis/shared/custom_icons.dart';

import 'styles.dart';

final _styles = DrawerContactsStyles();

// ignore: constant_identifier_names
enum Type { WhatsApp, Cel, Email }

class ContactInfo extends StatelessWidget {
  final int currentContactIndex;

  const ContactInfo({
    Key? key,
    required this.currentContactIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<ContactsModel> contacts =
        (context.watch<ContactsBloc>().state as ContactsSuccess).result.data;

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                "my_contacts.contact".i18n,
                style: _styles.lightText(14.sp),
              ),
              SizedBox(
                width: 117.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: const Icon(CustomIcons.i_llamada),
                          ),
                          Text(
                            "my_contacts.telephone".i18n,
                            style: _styles.regularText(
                              10.sp,
                              Color(0xff49339D),
                            ),
                            textScaleFactor: 1.0,
                          ),
                        ],
                      ),
                      onTap: () => launchExternalEvent(
                        contacts[currentContactIndex].telefono ?? '',
                        Type.Cel,
                      ),
                    ),
                    InkWell(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: const Icon(CustomIcons.i_whatsapp_solido,
                                color: Colors.green),
                          ),
                          Text(
                            "my_contacts.whatsApp".i18n,
                            style: _styles.regularText(
                              10.sp,
                              const Color(0xff49339D),
                            ),
                            textScaleFactor: 1.0,
                          ),
                        ],
                      ),
                      onTap: () => launchExternalEvent(
                        contacts[currentContactIndex].telefono ?? '',
                        Type.WhatsApp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                "my_contacts.email".i18n,
                style: _styles.lightText(14.sp),
              ),
              InkWell(
                child: SizedBox(
                  width: 180.w,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: const Icon(
                          CustomIcons.i_email,
                        ),
                      ),
                      AutoSizeText(
                        contacts[currentContactIndex].mail ?? '',
                        style: _styles.lightText(
                          12.sp,
                          const Color(0xff49339D),
                        ),
                        minFontSize: 5,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                onTap: () => launchExternalEvent(
                  contacts[currentContactIndex].mail ?? '',
                  Type.Email,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future launchExternalEvent(String value, Type type) async {
    String uri;

    switch (type) {
      case Type.Email:
        uri = "mailto:$value";
        break;

      case Type.WhatsApp:
        uri = "https://wa.me/$value/?text=Hola";
        break;
      default:
        uri = "tel:$value";
    }

    if (!await launchUrl(Uri.parse(uri))) {
      throw 'Could not launch $uri';
    }
  }
}
