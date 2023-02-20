import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:iclavis/blocs/project/project_bloc.dart';
import 'package:iclavis/blocs/new_request_user_support/new_request_user_support_bloc.dart';
import 'package:iclavis/models/project_model.dart';
import 'package:iclavis/screens/home/components/tabbar_views/user_support_views/request_form_gci/request_form.dart';
import 'package:iclavis/widgets/widgets.dart';


import '../styles.dart';

final _styles = UserSupportViewsStyles();

class NewRequest extends StatefulWidget {
  const NewRequest({Key? key}) : super(key: key);

  @override
  _NewRequestState createState() => _NewRequestState();
}

class _NewRequestState extends State<NewRequest> {
  @override
  void didChangeDependencies() {
    List<ProjectModel> projects =
        (context.read<ProjectBloc>().state as ProjectSuccess).result.data;

    int currentProjectIndex = projects.indexWhere((e) => e.isCurrent);

    if (currentProjectIndex == -1) {
      currentProjectIndex = 0;
    }

    final bloc = context.read<NewRequestUserSupportBloc>();

    if (bloc.state is! NewRequestUserSupportSuccess) {
      bloc.add(
        NewRequestUserSupportCategoriesLoaded(
          apiKey: projects[currentProjectIndex].inmobiliaria!.gci!.apikey!,
        ),
      );
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double bottomHeight = MediaQuery.of(context).viewInsets.bottom;
    String i18n(String text) => FlutterI18n.translate(context, text);
    return BlocListener<NewRequestUserSupportBloc, NewRequestUserSupportState>(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        reverse: bottomHeight == 0 ? false : true,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomHeight),
          child: Container(
            height: 386.h,
            padding: const EdgeInsets.only(bottom: 60),
            child: Card(
              elevation: 3,
              shape: _styles.cardCircularBorder(4.w),
              child: const RequestForm(),
            ),
          ),
        ),
      ),
      listener: (context, state) {
        if (state is! NewRequestUserSupportInProgress) {
          removeWaitAnimation();
          if (state is NewRequestUserSupportSendedSuccess) {
            ExceptionOverlay(context: context, message: i18n('form.Excepcion_Envio_Exitoso'));
          } else if (state is NewRequestUserSupportFailure) {
            if (state.result.message!.contains('server')) {
              ModalOverlay(
                context: context,
                message: 'Parece que hay problemas con nuestro servidor.'
                    ' Aprovecha de despejar la mente e intenta más tarde.',
                title: '¡Ups!',
                buttonTitle: 'Entendido',
              );
            } else {
              ExceptionOverlay(context: context, message: state.result.message??'');
            }
          }
        } else {
          showWaitAnimation(context);
        }
      },
    );
  }
}
