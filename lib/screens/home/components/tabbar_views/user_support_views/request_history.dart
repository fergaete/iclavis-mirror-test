import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'package:iclavis/blocs/project/project_bloc.dart';
import 'package:iclavis/blocs/project_user_support/project_user_support_bloc.dart';
import 'package:iclavis/blocs/user/user_bloc.dart';
import 'package:iclavis/blocs/history_user_support/history_user_support_bloc.dart';
import 'package:iclavis/models/project_model.dart';
import 'package:iclavis/models/property_model.dart';
import 'package:iclavis/models/user_model.dart';
import 'package:iclavis/shared/custom_icons.dart';
import 'package:iclavis/widgets/widgets.dart';

import 'resquest_history/request_history_card.dart';

class RequestHistory extends StatefulWidget {
  const RequestHistory({Key? key}) : super(key: key);

  @override
  _RequestHistoryState createState() => _RequestHistoryState();
}

class _RequestHistoryState extends State<RequestHistory> {
  bool isPanelOpen = false;

  late HistoryUserSupportBloc bloc;
  late ProjectUserSupportState bloc2;
  late Negocio selectProperties;
  late UserModel user;
  late List<ProjectModel> projects;
  late int currentProjectIndex;
  @override
  void didChangeDependencies() {
    user = (context.read<UserBloc>().state as UserSuccess).user;

    projects =
        (context.read<ProjectBloc>().state as ProjectSuccess).result.data;

    currentProjectIndex = projects.indexWhere((e) => e.isCurrent);

    bloc = context.read<HistoryUserSupportBloc>();
    bloc2 =context.read<ProjectUserSupportBloc>().state ;
    selectProperties = ( bloc2 as ProjectUserSupportSelect).projectSelect;
    if (bloc.state is! HistoryUserSupportSuccess) {
      bloc.add(
        HistoryUserSupportLoaded(
          apiKey: projects[currentProjectIndex].inmobiliaria!.pvi!.first.apikey!,
          dni: user.dni!,
          idPropiedad:  selectProperties.producto!.idPvi!,
        ),
      );
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    String i18n(String text) => FlutterI18n.translate(context,text);

    return BlocBuilder<ProjectUserSupportBloc,
        ProjectUserSupportState>(
        builder: (context, state) {
          if (state is ProjectUserSupportSelect) {
            selectProperties = state.projectSelect;
            bloc.add(
              HistoryUserSupportLoaded(
                apiKey: projects[currentProjectIndex].inmobiliaria!.pvi!.first.apikey!,
                dni: user.dni!,
                idPropiedad:  selectProperties.producto!.idPvi!,
              ),
            );

          }
          return RefreshIndicator(
            onRefresh: () async => bloc.add(
              HistoryUserSupportLoaded(
                apiKey: projects[currentProjectIndex].inmobiliaria!.pvi!.first.apikey!,
                dni: user.dni!,
                idPropiedad: selectProperties.producto!.idPvi!,
              ),
            ),
            child: BlocConsumer<HistoryUserSupportBloc, HistoryUserSupportState>(
              listener: (_, state) {
                if (state is HistoryUserSupportFailure) {
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
                if (state is HistoryUserSupportSuccess) {
                  return state.result.data.isEmpty
                      ? ListView(
                    shrinkWrap: true,
                    children: [
                      SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: EmptyCard(
                            text:i18n("form.history_empty"),
                            icon: CustomIcons.i_consulta,
                          ),
                        ),
                      ),
                    ],
                  )
                      : ListView.builder(
                    itemCount: state.result.data.length,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (_, i) => RequestHistoryCard(
                      historyIndex: i,
                      producto:selectProperties.producto,
                    ),
                  );
                } else if (state is HistoryUserSupportFailure) {
                  return Center(child: Text(state.result.message??''));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          );
        })
     ;

  }
}
