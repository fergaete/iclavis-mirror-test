import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/blocs/contacts/contacts_bloc.dart';
import 'package:iclavis/models/contacts_model.dart';
import 'package:iclavis/shared/custom_icons.dart';

import 'drawer_custom_header.dart';
import 'drawer_item.dart';
import 'drawer_profile/drawer_profile.dart';
import 'drawer_property/drawer_property.dart';
import 'drawer_contacts/drawer_contacts.dart';
import 'drawer_faqs/drawer_faqs.dart';

final List<String> itemsTitle = [
  "button.my_profile",
  "button.my_properties",
  "button.contacts",
  "button.faqs",
  "button.logout",
];

final List<IconData> itemsLeading = [
  CustomIcons.i_perfil,
  CustomIcons.i_propiedades,
  CustomIcons.i_contactos,
  CustomIcons.i_preguntas,
  CustomIcons.i_cerrar_sesio_n,
];

List<Widget> itemsDrawer = const [
  DrawerProfile(),
  DrawerProperty(),
  DrawerContacts(),
  DrawerFaqs(),
  DrawerProfile(),
];

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  static var _contacts = [];

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {

  String version ="";
  @override
  void initState() {
    getVersion();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final state = context.watch<ContactsBloc>().state;

    if (state is ContactsSuccess) {
      HomeDrawer._contacts = (state.result.data as List<ContactsModel>);
    
    }

    return SizedBox(
      width: 274.w,
      child: Drawer(
        child: BlocBuilder<ContactsBloc, ContactsState>(
          builder: (_, state) {
            return Column(children: [
              Expanded(child:
              ListView(
                physics: ClampingScrollPhysics(),
                children: [
                  CustomDrawerHeader(),
                  DrawerItem(
                    itemsTitle: itemsTitle,
                    itemsLeading: itemsLeading,
                    itemsDrawer: itemsDrawer,
                    isEnabledContacts: HomeDrawer._contacts.isNotEmpty,
                  ),
                ],
              )),
              Text(version,
              style: TextStyle(
                color: Colors.grey.withOpacity(0.8)
              ),)
            ],);
          },
        ),
      ),
    );
  }
  
  getVersion() async {

    /*PackageInfo packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        version = "${packageInfo.version}+${packageInfo.buildNumber}";
      });*/

  }
}
