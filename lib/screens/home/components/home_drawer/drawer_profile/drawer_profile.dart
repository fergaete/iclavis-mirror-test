import 'package:flutter/material.dart';

import 'package:flutter_i18n/flutter_i18n.dart';

import 'drawer_profile_components.dart';
import '../drawer_app_bar.dart';

/*class UserPropertie {
  final String label;
  final bool isEditable;

  const UserPropertie({this.label, this.isEditable});

  @override
  String toString() => 'label: $label -> isEditable: $isEditable';
}

Map<String, bool> userMap = {
  "RUT/DNI": null,
  "Fecha de Nacimiento": null,
  "Nacionalidad": null,
  "Celular": true,
  "Email": true,
  "Dirección": true,
  "Comuna": true,
  "Provincia": true,
  "Región": true,
};*/

class DrawerProfile extends StatefulWidget {
  const DrawerProfile({Key? key}) : super(key: key);

  @override
  _DrawerProfileState createState() => _DrawerProfileState();
}

class _DrawerProfileState extends State<DrawerProfile> {
  bool isEditting = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: ProfileAppBar(title:FlutterI18n.translate(context, "profile.profile_title")),
        body: DrawerProfileComponents(),
        /* floatingActionButton: SaveButton(
          isEditting: isEditting,
          onPressed: () => setState(() {
            isEditting = !isEditting;
          }),
        ), */
      ),
    );
  }
}
