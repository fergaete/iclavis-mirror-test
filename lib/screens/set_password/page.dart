import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/blocs/signup/signup_bloc.dart';
import 'package:iclavis/personalizacion.dart';
import 'package:iclavis/shared/custom_icons.dart';
import 'package:iclavis/routes/route_paths.dart';
import 'package:iclavis/widgets/exception_overlay/widget.dart';
import 'package:iclavis/widgets/modal_overlay/widget.dart';

import 'components.dart';

class SetPasswordPage extends StatelessWidget {
  SetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupBloc(),
      child: SafeArea(
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
          body: BlocListener<SignupBloc, SignupState>(
            child: const SetPasswordComponents(),
            listener: (context, state) {
              if (state is SignupSuccess) {
                Navigator.pushReplacementNamed(context, RoutePaths.Login);
              }
              if (state is SignupFailure) {
                if (state.result!.message!.contains('server')) {
                  ModalOverlay(
                    context: context,
                    message: 'Parece que hay problemas con nuestro servidor.'
                        ' Aprovecha de despejar la mente e intenta más tarde.',
                    title: '¡Ups!',
                    buttonTitle: 'Entendido',
                    colorAllText: Colors.white,
                    backgroundColor: Color(0xff1A2341),
                  );
                } else {
                  ExceptionOverlay(
                    context: context,
                    message: state.result?.message??'',
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
