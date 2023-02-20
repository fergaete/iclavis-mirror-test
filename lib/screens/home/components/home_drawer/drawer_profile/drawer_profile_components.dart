import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/blocs/user/user.dart';
import 'package:iclavis/models/user_model.dart';

import 'profile_image.dart';
import 'profile_info.dart';

class DrawerProfileComponents extends StatefulWidget {
  DrawerProfileComponents({Key? key}) : super(key: key);

  @override
  _DrawerProfileComponentsState createState() =>
      _DrawerProfileComponentsState();
}

class _DrawerProfileComponentsState extends State<DrawerProfileComponents> {
  final GlobalKey<FormBuilderState> formBuilderKey =
      GlobalKey<FormBuilderState>();

  late UserModel user;

  @override
  void didChangeDependencies() {
    final state = context.read<UserBloc>().state;

    if (state is UserSuccess) {
      user = state.user;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Align(
        alignment: AlignmentDirectional.center,
        child: SizedBox(
          width: 315.w,
          child: Column(
            children: <Widget>[
              ProfileImage(user: user),
              Expanded(
                child: ProfileInfo(user: user, formBuilderKey: formBuilderKey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
