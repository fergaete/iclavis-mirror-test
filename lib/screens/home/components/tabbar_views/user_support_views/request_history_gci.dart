import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:iclavis/blocs/project/project_bloc.dart';
import 'package:iclavis/blocs/user/user_bloc.dart';
import 'package:iclavis/blocs/history_user_support_gci/history_user_support_gci_bloc.dart';
import 'package:iclavis/models/project_model.dart';
import 'package:iclavis/models/user_model.dart';
import 'package:iclavis/shared/custom_icons.dart';
import 'package:iclavis/widgets/widgets.dart';

import 'resquest_history/request_history_card_gci.dart';



class RequestHistoryGci extends StatefulWidget {
  const RequestHistoryGci({Key? key}) : super(key: key);

  @override
  _RequestHistoryGciState createState() => _RequestHistoryGciState();
}

class _RequestHistoryGciState extends State<RequestHistoryGci> {
  bool isPanelOpen = false;

  late HistoryUserSupportGciBloc bloc;
  late UserModel user;
  late List<ProjectModel> projects;
  late int currentProjectIndex;

  @override
  void didChangeDependencies() {
    user = (context.read<UserBloc>().state as UserSuccess).user;

    projects =
        (context.read<ProjectBloc>().state as ProjectSuccess).result.data;

    currentProjectIndex = projects.indexWhere((e) => e.isCurrent);

    bloc = context.read<HistoryUserSupportGciBloc>();

    if (bloc.state is! HistoryUserSupportGciSuccess) {
      bloc.add(
        HistoryUserSupportGciLoaded(
          apiKey: projects[currentProjectIndex].inmobiliaria!.gci!.apikey!,
          dni: user.dni!,
          idProyecto: projects[currentProjectIndex].proyecto!.gci!.id!,
        ),
      );
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => bloc.add(
        HistoryUserSupportGciLoaded(
          apiKey: projects[currentProjectIndex].inmobiliaria!.gci!.apikey!,
          dni: user.dni!,
          idProyecto: projects[currentProjectIndex].proyecto!.gci!.id!,
        ),
      ),
      child: BlocConsumer<HistoryUserSupportGciBloc, HistoryUserSupportGciState>(
        listener: (_, state) {
          if (state is HistoryUserSupportGciFailure) {
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
          if (state is HistoryUserSupportGciSuccess) {
            return state.result.data.isEmpty
                ? ListView(
              shrinkWrap: true,
              children: const [
                SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  //padding: EdgeInsets.only(top: 150.h)
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: EmptyCard(
                      text:
                      'Aquí podrás revisar el historial de tus solicitudes realizadas',
                      icon: CustomIcons.i_consulta,
                    ),
                  ),
                ),
              ],
            )
                : ListView.builder(
              itemCount: state.result.data.length,
              physics: ClampingScrollPhysics(),
              itemBuilder: (_, i) => RequestHistoryCardGci(
                historyIndex: i,
              ),
            );
          } else if (state is HistoryUserSupportGciFailure) {
            return Center(child: Text(state.result.message??''));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
