import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:go_router/go_router.dart';

import 'package:iclavis/blocs/authentication/authentication_bloc.dart';
import 'package:iclavis/blocs/first_start/first_start_bloc.dart';
import 'package:iclavis/blocs/project/project_bloc.dart';
import 'package:iclavis/blocs/user/user_bloc.dart';
import 'package:iclavis/models/project_model.dart';
import 'package:iclavis/personalizacion.dart';
import 'package:iclavis/routes/route_paths.dart';
import 'package:iclavis/blocs/notification/notification_bloc.dart';
import 'package:iclavis/widgets/modal_overlay/widget.dart';
import 'package:iclavis/widgets/widgets.dart';

import 'components/components.dart';

class PreHomePage extends StatefulWidget {
  PreHomePage({Key? key}) : super(key: key);

  @override
  _PreHomePageState createState() => _PreHomePageState();
}

class _PreHomePageState extends State<PreHomePage> {

  @override
  void didChangeDependencies() {
    final bloc = context.read<ProjectBloc>();

    if (bloc.state is! ProjectSuccess && context.read<UserBloc>().state is UserSuccess ) {
      final user = (context.read<UserBloc>().state as UserSuccess).user;

      bloc.add(ProjectsLoaded(dni: user.dni??''));
    }else{
      context.read<UserBloc>().add(UserLoaded());
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    String i18n(String text) => FlutterI18n.translate(context, text);
    return SafeArea(
      child: Scaffold(
        appBar: const PreHomeAppBar(),
        body: BlocConsumer<ProjectBloc, ProjectState>(
          listener: (_, state) {
            if (state is ProjectFailure) {
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
          builder: (_, state) {
            if (state is ProjectSuccess) {
              final projects = state.result.data as List<ProjectModel>;

              if (projects.length == 1) {
                FirebaseAnalytics.instance
                    .logEvent(name: 'select_project', parameters: {
                  'proyectoId': projects.first.proyecto?.gci?.id,
                  'proyectoGlosa': projects.first.proyecto?.gci?.glosa,
                  'inmobiliaria': projects.first.inmobiliaria?.gci?.id,
                });

                return Middleware(projectId: projects.first.proyecto!.gci!.id!);
              }

              if (state.result.data.isEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ModalOverlay(
                      context: context,
                  message: "exepcion.Exepcion_usuario_sin_negocios",
                      title: '¡Ups!',
                      buttonTitle: 'Entendido',
                      colorAllText: Customization.variable_1,
                      backgroundColor: Customization.variable_3,
                      onPressed: () {
                        context
                            .read<AuthenticationBloc>()
                            .add(AuthenticationLoggedOut());
                        context
                            .read<FirstStartBloc>()
                            .add(FirstStartFlagLoaded());
                        Navigator.pushNamedAndRemoveUntil(
                            context, RoutePaths.Login, (route) => false);
                      });
                });
                return Center(
                  child: Text( i18n("pre_home.empty_proyect")),
                );
              }

              return const PreHomeComponents();
            }
            if (state is ProjectFailure) {
              return Center(
                child: Text(
                  state.result.message ??'',
                ),
              );
            } else {
              if(context.read<UserBloc>().state is UserSuccess){
                final user = (context.read<UserBloc>().state as UserSuccess).user;
                context.read<ProjectBloc>().add(ProjectsLoaded(dni: user.dni??''));
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

class Middleware extends StatefulWidget {
  final int projectId;

  Middleware({Key? key, required this.projectId}) : super(key: key);

  @override
  _MiddlewareState createState() => _MiddlewareState();
}

class _MiddlewareState extends State<Middleware> {
  @override
  void didChangeDependencies() {
    context.read<ProjectBloc>().add(CurrentProjectSaved(id: widget.projectId));
    NotificationBloc.projectId = widget.projectId;

    WidgetsBinding.instance.addPostFrameCallback(
      (_) =>  GoRouter.of(context).pushReplacementNamed(
          RouteName.Home),
    );

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}
