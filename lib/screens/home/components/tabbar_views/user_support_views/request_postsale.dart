import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/blocs/post_sale_form/post_sale_form_bloc.dart';
import 'package:iclavis/blocs/post_sale_form_data/post_sale_form_data_bloc.dart';
import 'package:iclavis/blocs/project/project_bloc.dart';
import 'package:iclavis/blocs/project_user_support/project_user_support_bloc.dart';
import 'package:iclavis/models/post_sale_form_model.dart';
import 'package:iclavis/models/project_model.dart';
import 'package:iclavis/models/property_model.dart';
import 'package:iclavis/screens/home/components/tabbar_views/user_support_views/postsale_form/resume_card.dart';
import 'package:iclavis/widgets/widgets.dart';

import 'postsale_form/new_form.dart';

import 'styles.dart';

final _styles = UserSupportViewsStyles();

class RequestPostSale extends StatefulWidget {
  const RequestPostSale({super.key});

  @override
  _RequestPostSaleState createState() => _RequestPostSaleState();
}

class _RequestPostSaleState extends State<RequestPostSale> {
  List<PostSaleFormModel> lisForm = [];
  late Negocio selectProperties;
  late bool firstTime = true;
  late ProjectModel currentProject;

  @override
  void didChangeDependencies() {
    final projects = (context.read<ProjectBloc>().state as ProjectSuccess)
        .result
        .data as List<ProjectModel>;

    currentProject = projects.where((e) => e.isCurrent).first;

    if (firstTime) {
      BlocProvider.of<PostSaleFormDataBloc>(context)
          .add(PostSaleFormDataInit());
      firstTime = false;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    String i18n(String text) => FlutterI18n.translate(context, text);
    double bottomHeight = MediaQuery.of(context).viewInsets.bottom;
    return BlocListener<PostSaleFormBloc, PostSaleFormState>(
      child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          reverse: bottomHeight == 0 ? false : true,
          child: BlocBuilder<ProjectUserSupportBloc, ProjectUserSupportState>(
            builder: (context, state) {
              if (state is ProjectUserSupportSelect) {
                selectProperties = state.projectSelect;
              }

              if (state is ProjectUserSupportSelect &&
                  selectProperties.producto!.fechaEntrega == "0000-00-00") {
                return EmptyCard(
                  text: "Esta propiedad no está entregada, por ende no puedes"
                      " ingresar solicitudes de posventa aún.\nCualquier duda o"
                      " consulta, contacte a su ejecutivo de ventas.",
                  icon: Icons.construction,
                  color: Colors.grey.withOpacity(0.2),
                );
              }
              return Column(
                children: [
                  BlocConsumer<PostSaleFormDataBloc, PostSaleFormDataState>(
                      listener: (context, state) {
                    if (state is PostSaleFormDataSuccess) {
                      setState(() {
                        lisForm = state.listFormData;
                      });
                    }
                  }, builder: (context, state) {
                    if (state is PostSaleFormDataSuccess) {
                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.listFormData.length,
                          itemBuilder: (_, i) {
                            return Card(
                                elevation: 3,
                                shape: _styles.cardCircularBorder(4.w),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      10, 10, 10, bottomHeight),
                                  child: state.listFormData[i].estado == 0
                                      ? NewForm(state.listFormData[i].id!)
                                      : ResumeCard(
                                          itemFormData: state.listFormData[i],
                                        ),
                                ));
                          });
                    } else {
                      return Container();
                    }
                  }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 36.h,
                        width: 300.w,
                        margin: EdgeInsets.symmetric(vertical: 20.h),
                        child: FormButton(
                          label:
                              i18n("form.Postventa_Boton_Nuevo_Requerimiento"),
                          labelStyle: _styles.mediumText(
                            18.sp,
                            Colors.white,
                          ),
                          isEnabled:
                              lisForm.where((e) => e.estado == 0).isEmpty &&
                                  lisForm.length <= 5,
                          onPressed: () {
                            BlocProvider.of<PostSaleFormDataBloc>(context)
                                .add(PostSaleFormDataAddRequest());
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 36.h,
                        width: 150.w,
                        margin: EdgeInsets.symmetric(vertical: 20.h),
                        child: FormButton(
                          label: i18n("form.send_request_button"),
                          isEnabled:
                              lisForm.where((e) => e.estado == 0).isEmpty,
                          onPressed: () {
                            final projects = (context.read<ProjectBloc>().state
                                    as ProjectSuccess)
                                .result
                                .data as List<ProjectModel>;

                            final properties = (context
                                    .read<ProjectUserSupportBloc>()
                                    .state as ProjectUserSupportSelect)
                                .projectSelect;

                            ProjectModel currentProject =
                                projects.where((e) => e.isCurrent).first;
                            BlocProvider.of<PostSaleFormBloc>(context).add(
                                PostSaleFormSended(
                                    apiKey: currentProject
                                        .inmobiliaria!.pvi!.first.apikey!,
                                    listPostSaleForm: lisForm,
                                    idProduct: properties.producto!.idPvi!));
                          },
                        ),
                      ),
                    ],
                  )
                ],
              );
            },
          )),
      listener: (context, state) {
        if (state is! PostSaleFormSendedSuccessProgress) {
          try {
            removeWaitAnimation();
          } catch (e) {}

          if (state is PostSaleFormSendedSuccess) {
            ExceptionOverlay(context: context, message: 'Envío exitoso!');
            BlocProvider.of<PostSaleFormDataBloc>(context)
                .add(PostSaleFormDataInit());
          } else if (state is PostSaleFormSendedFailure) {
            if (state.result.message!.contains('server')) {
              ModalOverlay(
                context: context,
                message: 'Parece que hay problemas con nuestro servidor.'
                    ' Aprovecha de despejar la mente e intenta más tarde.',
                title: '¡Ups!',
                buttonTitle: 'Entendido',
              );
            } else {
              ExceptionOverlay(
                  context: context, message: state.result.message ?? '');
            }
          }
        } else {
          showWaitAnimation(context);
        }
      },
    );
  }
}
