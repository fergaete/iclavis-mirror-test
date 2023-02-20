import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:iclavis/blocs/project/project_bloc.dart';
import 'package:iclavis/blocs/new_request_user_support/new_request_user_support_bloc.dart';
import 'package:iclavis/models/project_model.dart';
import 'package:iclavis/widgets/widgets.dart';

import '../request_form_gci/request_form.dart';
import '../styles.dart';
import '../user_support_messages.dart';

final _styles = UserSupportViewsStyles();

class NewRequest extends StatefulWidget {
  final bool pvi;
  const NewRequest({Key? key, this.pvi=false}) : super(key: key);

  @override
  _NewRequestState createState() => _NewRequestState();
}

class _NewRequestState extends State<NewRequest> {


  bool isSac=false;
  late List<ProjectModel> projects;
  int currentProjectIndex=0;
  @override
  void didChangeDependencies() {
    projects =
        (context.read<ProjectBloc>().state as ProjectSuccess).result.data;

    currentProjectIndex = projects.indexWhere((e) => e.isCurrent);

    if (currentProjectIndex == -1) {
      currentProjectIndex = 0;
    }

    final bloc = context.read<NewRequestUserSupportBloc>();


    if(widget.pvi){
      isSac= projects[currentProjectIndex].inmobiliaria!.pvi![0].poseeSac!;
      if (bloc.state is! NewRequestUserSupportSuccess) {
        bloc.add(
          NewRequestUserSupportCategoriesLoadedPvi(
            apiKey: projects[currentProjectIndex].inmobiliaria!.pvi![0].apikey!,
          ),
        );
      }

    }else{
      isSac = projects[currentProjectIndex].proyecto!.gci!.formularioContacto!.activo!;
      if (bloc.state is! NewRequestUserSupportSuccess) {
        bloc.add(
          NewRequestUserSupportCategoriesLoaded(
            apiKey: projects[currentProjectIndex].inmobiliaria!.gci!.apikey!,
          ),
        );
      }
    }


    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double bottomHeight = MediaQuery.of(context).viewInsets.bottom;

    return BlocListener<NewRequestUserSupportBloc, NewRequestUserSupportState>(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        reverse: bottomHeight == 0 ? false : true,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomHeight),
          child: isSac?Container(
            height: 386.h,
            padding: const EdgeInsets.only(bottom: 60),
            child: Card(
              elevation: 3,
              shape: _styles.cardCircularBorder(4.w),
              child: RequestForm(
                pvi:widget.pvi
              ),
            ),
          ):UserSupportMessages(
          message:projects[currentProjectIndex].proyecto!.gci!.formularioContacto!.mensaje,
        ),
        ),
      ),
      listener: (context, state) {
        if (state is! NewRequestUserSupportInProgress) {
          removeWaitAnimation();
          if (state is NewRequestUserSupportSendedSuccess) {
            ExceptionOverlay(context: context, message: 'Envío exitoso!');
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
