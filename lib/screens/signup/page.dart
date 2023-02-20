import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:iclavis/blocs/signup/signup_bloc.dart';
import 'package:iclavis/blocs/user/user_bloc.dart';
import 'package:iclavis/personalizacion.dart';
import 'package:iclavis/routes/routes.dart';
import 'package:iclavis/utils/extensions/analytics.dart';
import 'package:iclavis/widgets/widgets.dart';

import 'components/signup_components.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool hasException = false;
  String exceptionMessage = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupBloc(),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Customization.variable_6,
          body: BlocListener<SignupBloc, SignupState>(
            child: SignUpComponents(
              hasException: hasException,
              exceptionMessage: exceptionMessage,
            ),
            listener: (context, state) {
              if (state is SignupSuccess) {
                Analytics().addEventUser(name: 'registro');
                context.read<UserBloc>().add(UserLoaded());
                Navigator.pushReplacementNamed(
                    context, RoutePaths.UserVerification);
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
                    backgroundColor: const Color(0xff1A2341),
                  );
                } else {
                  setState(() {
                    exceptionMessage = state.result!.message!;
                    hasException = true;
                  });
                }

                if (state.result!.data != null) {
                  ExceptionOverlay(
                    context: context,
                    message: state.result?.message??'',
                  );

                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.pushReplacementNamed(context, state.result!.data);
                  });
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
