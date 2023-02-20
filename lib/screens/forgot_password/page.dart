import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/blocs/signup/signup_bloc.dart';
import 'package:iclavis/personalizacion.dart';
import 'package:iclavis/shared/custom_icons.dart';

import '../../utils/Translation/translation.dart';
import 'components/Input_code.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Translation(context);
    return BlocProvider(
      create: (_) => SignupBloc(),
      child: SafeArea(
          child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Customization.variable_6,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Customization.variable_6,
            leading: GestureDetector(
              child: Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Icon(
                  CustomIcons.i_volver_atras,
                  size: 16.sp,
                  color: Customization.variable_7,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: const InputCode(),
        ),
      )),
    );
  }
}
