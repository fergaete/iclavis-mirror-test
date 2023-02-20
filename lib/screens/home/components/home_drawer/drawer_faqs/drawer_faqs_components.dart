import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:iclavis/blocs/faq/faq_bloc.dart';
import 'package:iclavis/blocs/project/project_bloc.dart';
import 'package:iclavis/models/faq_model.dart';
import 'package:iclavis/models/project_model.dart';
import 'package:iclavis/widgets/modal_overlay/widget.dart';

import 'faqs_category.dart';
import 'styles.dart';

final _styles = DrawerFaqsStyles();

class DrawerFaqsComponents extends StatefulWidget {
  DrawerFaqsComponents({Key? key}) : super(key: key);

  @override
  _DrawerFaqsComponentsState createState() => _DrawerFaqsComponentsState();
}

class _DrawerFaqsComponentsState extends State<DrawerFaqsComponents> {
  @override
  void didChangeDependencies() {
    final faqState = context.read<FaqBloc>().state;

    if (faqState is! FaqSuccess) {
      List<ProjectModel> projects =
          (context.read<ProjectBloc>().state as ProjectSuccess).result.data;

      final currentProject = projects.firstWhere((p) => p.isCurrent == true);

      context.read<FaqBloc>().add(FaqLoaded(
            apiKey: currentProject.inmobiliaria!.gci!.apikey!,
            idProyecto: currentProject.proyecto!.gci!.id!,
          ));
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: 327.w,
        child: BlocConsumer<FaqBloc, FaqState>(
          listener: (_, state) {
            if (state is FaqFailure) {
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
            if (state is FaqSuccess) {
              final faq = state.result.data as List<FaqModel>;
              faq.removeWhere((e) => e.preguntasFrecuentes.isEmpty);
              if (faq.isEmpty) {
                return const Center(
                  child: Text('No hay Preguntas Frequentes para este proyecto'),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.only(top: 34.h),
                itemCount: faq.length,
                itemBuilder: (_, i) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: Card(
                      elevation: 3.h,
                      shadowColor: const Color(0xffdbdbdb),
                      shape: _styles.cardShape,
                      margin: EdgeInsets.fromLTRB(4.w, 0, 4.w, 0),
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight: 80.h,
                        ),
                        child: FaqsCategory(
                          faq: faq[i],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is FaqFailure) {
              return Center(child: Text(state.result.message??''));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
