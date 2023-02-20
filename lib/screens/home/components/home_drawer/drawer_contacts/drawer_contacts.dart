import 'package:flutter/material.dart';

import 'package:flutter_i18n/flutter_i18n.dart';
import 'drawer_contacts_components.dart';
import '../drawer_app_bar.dart';

class DrawerContacts extends StatelessWidget {
  const DrawerContacts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: ProfileAppBar(title: FlutterI18n.translate(context, "my_contacts.my_contacts_title")),
        body: const DrawerContactsComponents(),
      ),
    );
  }
}
