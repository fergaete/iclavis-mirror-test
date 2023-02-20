import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:go_router/go_router.dart';

import 'package:iclavis/blocs/user/user_bloc.dart';
import 'package:iclavis/blocs/first_start/first_start_bloc.dart';
import 'package:iclavis/blocs/login/login_bloc.dart';
import 'package:iclavis/blocs/signup/signup_bloc.dart';
import 'package:iclavis/personalizacion.dart';
import 'package:iclavis/routes/routes.dart';
import 'package:iclavis/widgets/widgets.dart';

import 'components.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool sawOnboarding = false;

  bool hasException = false;
  String exceptionMessage = '';

  @override
  void didChangeDependencies() {
    final state = context.read<FirstStartBloc>().state;

    if (state is FirstStartSuccess) {
      sawOnboarding = state.hasFirstStart;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginBloc()),
        BlocProvider(create: (_) => SignupBloc()),
      ],
      child: SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Customization.variable_6,
            body: MultiBlocListener(
              listeners: [
                BlocListener<LoginBloc, LoginState>(
                  listener: (context, state) async {
                    if (state is LoginInProgress) {
                      showWaitAnimation(context);
                    } else {
                      removeWaitAnimation();
                    }
                    if (state is LoginSuccess) {
                      context.read<UserBloc>().add(UserLoaded());
                      await FirebaseAnalytics.instance
                          .logEvent(name: 'login', parameters: {
                        'user': state.result.data,
                      });

                      if (sawOnboarding) {
                        if (!mounted) return;
                        GoRouter.of(context).pushReplacementNamed(
                          RouteName.PreHome,
                        );
                      } else {
                        if (!mounted) return;

                          GoRouter.of(context).pushReplacementNamed(
                          RouteName.Onboarding
                        );
                      }
                    }
                    if (state is LoginFailure) {
                      if (state.result.message!.contains('server')) {
                        ModalOverlay(
                          context: context,
                          message: "exepcion.Exepcion_problemas_servidor",
                          title: '¡Ups!',
                          buttonTitle: 'Entendido',
                          colorAllText: Colors.white,
                          backgroundColor: const Color(0xff1A2341),
                        );
                      } else {
                        setState(() {
                          exceptionMessage = FlutterI18n.translate(
                                  context, state.result.message!);
                          hasException = true;
                        });
                      }

                      if (state.result.data != null) {
                        Future.delayed(const Duration(seconds: 3), () {
                          Navigator.pushReplacementNamed(
                              context, state.result.data);
                        });
                      }
                    }
                  },
                ),
                BlocListener<SignupBloc, SignupState>(
                  listener: (context, state) async {
                    if (state is ForgotPasswordButtonInProgress) {
                      showWaitAnimation(context);
                    } else {
                      removeWaitAnimation();
                    }
                    if (state is ForgotPasswordButtonFailure) {
                      setState(() {
                        exceptionMessage = state.error;
                        hasException = true;
                      });
                    }
                    if (state is ForgotPasswordButtonSuccess) {
                      await Navigator.pushNamed(context, RoutePaths.ForgoPassword);
                    }
                  },
                ),
              ],
              child: LoginComponents(
                hasException: hasException,
                exceptionMessage: exceptionMessage,
              ),
            )),
      ),
    );
  }
}
