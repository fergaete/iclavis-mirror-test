import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'package:iclavis/blocs/contacts/contacts_bloc.dart';
import 'package:iclavis/widgets/modal_overlay/widget.dart';

import 'contact_card.dart';
import 'styles.dart';

final _styles = DrawerContactsStyles();

class DrawerContactsComponents extends StatelessWidget {
  const DrawerContactsComponents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String i18n(String text) => FlutterI18n.translate(context, text);
    
    return BlocConsumer<ContactsBloc, ContactsState>(
      listener: (_, state) {
        if (state is ContactsFailure) {
          if (state.result.message!.contains('server')) {
            ModalOverlay(
              context: context,
              message: 'Parece que hay problemas con nuestro servidor.'
                  ' Aprovecha de despejar la mente e intenta más tarde.',
              title: '¡Ups!',
              buttonTitle: 'Entendido',
            );
          }
        }
      },
      builder: (context, state) {
        if (state is ContactsSuccess) {
          return Center(
            child: SizedBox(
              width: 340.w,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 21.h),
                    child: Text(i18n("my_contacts.bussines_hours"),
                      style: _styles.hoursText,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    i18n("my_contacts.business_days"),
                    textAlign: TextAlign.center,
                    style: _styles.hoursText,
                  ),
                  const Expanded(
                    child: ContactCard(),
                  ),
                ],
              ),
            ),
          );
        } else if (state is ContactsFailure) {
          return const Center(
            child: Text('No hay contactos para este proyecto'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
