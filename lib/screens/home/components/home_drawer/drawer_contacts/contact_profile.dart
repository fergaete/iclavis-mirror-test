import 'package:flutter/material.dart';

//import 'package:expansion_card/expansion_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/blocs/contacts/contacts_bloc.dart';
import 'package:iclavis/models/contacts_model.dart';
import 'package:iclavis/widgets/widgets.dart';

import 'styles.dart';

final _styles = DrawerContactsStyles();

class ContactProfile extends StatelessWidget {
  final Function setHeight;
  final int currentContactIndex;

  const ContactProfile({
    Key? key,
    required this.setHeight,
    required this.currentContactIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<ContactsModel> contacts =
        (context.watch<ContactsBloc>().state as ContactsSuccess).result.data;

    return Column(
      children: [
        ExpansionCard(
          leading: CircleAvatar(
            radius: 25.5.w,
            backgroundColor: const Color(0xff9D9D9D),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 25.w,
              backgroundImage: const AssetImage(
                "assets/images/default_profile_image.png",
              ),
            ),
          ),
          titleWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                contacts[currentContactIndex].nombre??'',
                style: _styles.mediumText(14.sp),
              ),
              Text(
                contacts[currentContactIndex].cargo??'',
                style: _styles.lightText(
                  14.sp,
                ),
              ),
            ],
          ),
            icon: true,
          child:
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: EdgeInsets.only(right: 10.w),
                width: 251.w,
                child: Text(
                  contacts[currentContactIndex].contactarEnCasoDe??'',
                  style: _styles.lightText(14.sp),
                ),
              ),
            ),
        )
      ],
    );
  }
}
