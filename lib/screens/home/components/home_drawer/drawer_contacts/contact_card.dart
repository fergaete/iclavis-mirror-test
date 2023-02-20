import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:iclavis/blocs/contacts/contacts_bloc.dart';
import 'package:iclavis/models/contacts_model.dart';

import 'contact_info.dart';
import 'contact_profile.dart';
import 'styles.dart';

final _styles = DrawerContactsStyles();

class ContactCard extends StatefulWidget {
  const ContactCard({Key? key}) : super(key: key);

  @override
  _ContactCardState createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  double height = 195.h;

  late List<ContactsModel> contacts;

  @override
  void didChangeDependencies() {
    contacts =
        (context.read<ContactsBloc>().state as ContactsSuccess).result.data;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: contacts.length,
      padding: EdgeInsets.only(
        top: 17.h,
        bottom: 17.h,
      ),
      itemBuilder: (_, i) {
        return Padding(
          padding: EdgeInsets.only(bottom: 20.h),
          child: Card(
            elevation: 3.h,
            shadowColor: const Color(0xffdbdbdb),
            shape: _styles.cardShape,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ContactProfile(setHeight: setHeight, currentContactIndex: i),
                  SizedBox(
                    width: 308.w,
                    child: const Divider(
                      color: Color(0xffe7e7e7),
                      thickness: 1,
                    ),
                  ),
                  ContactInfo(currentContactIndex: i),
                  SizedBox(height: 20.h,)
                ],
              ),
          ),
        );
      },
    );
  }

  void setHeight(bool isPanelOpen) {
    if (isPanelOpen) {
      setState(() {
        height = 231.h;
      });
    } else {
      setState(() {
        height = 195.h;
      });
    }
  }
}
