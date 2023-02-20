import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/blocs/user_verification/user_verification_bloc.dart';
import 'package:iclavis/personalizacion.dart';
import 'package:iclavis/routes/routes.dart';
import 'package:iclavis/shared/custom_icons.dart';
import 'package:iclavis/widgets/widgets.dart';

import 'components/user_verification_components.dart';

class UserVerificationPage extends StatelessWidget {
  UserVerificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserVerificationBloc(),
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
          body: BlocListener<UserVerificationBloc, UserVerificationState>(
            child: const UserVerificationComponents(),
            listener: (context, state) {
              if (state is ConfirmSuccess) {
                Navigator.pushNamed(context, RoutePaths.SetPassword);
              } else if (state is ResendCodeSuccess) {
                ExceptionOverlay(
                  context: context,
                  message: '¡Código reenviado con éxito!',
                );
              } else if (state is UserVerificationFailure) {
                if (state.result.message!.contains('server')) {
                  ModalOverlay(
                    context: context,
                    message: 'Parece que hay problemas con nuestro servidor.'
                        ' Aprovecha de despejar la mente e intenta más tarde.',
                    title: '¡Ups!',
                    buttonTitle: 'Entendido',
                    colorAllText: Colors.white,
                    backgroundColor: Color(0xff1A2341),
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
