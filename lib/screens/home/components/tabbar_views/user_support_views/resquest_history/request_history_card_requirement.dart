import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/blocs/history_user_support_request/history_user_support_request_bloc.dart';
import 'package:iclavis/blocs/project/project_bloc.dart';
import 'package:iclavis/blocs/project_user_support/project_user_support_bloc.dart';
import 'package:iclavis/blocs/user/user_bloc.dart';
import 'package:iclavis/models/project_model.dart';
import 'package:iclavis/models/property_model.dart';
import 'package:iclavis/models/user_model.dart';
import 'package:iclavis/models/user_support_history_request_model.dart';
import 'package:iclavis/screens/home/components/tabbar_views/user_support_views/resquest_history/request_history_card_requeriment_dialog.dart';
import 'package:iclavis/shared/shared.dart';
import 'package:iclavis/widgets/widgets.dart';
import '../../../../../../shared/custom_newicons.dart';
import '../styles.dart';

final _styles = UserSupportViewsStyles();

class RequestHistoryCardList extends StatefulWidget {
  final String id;

  const RequestHistoryCardList(this.id, {Key? key}) : super(key: key);

  @override
  _RequestHistoryCardListState createState() => _RequestHistoryCardListState();
}

class _RequestHistoryCardListState extends State<RequestHistoryCardList> {
  late HistoryUserSupportRequestBloc bloc;
  late UserModel user;
  late List<ProjectModel> projects;
  late int currentProjectIndex;
  late ProjectUserSupportState bloc2;
  late Negocio selectProperties;
  late List<UserSupportHistoryRequestModel> requestList = [];

  @override
  void didChangeDependencies() {
    user = (context.read<UserBloc>().state as UserSuccess).user;

    projects =
        (context.read<ProjectBloc>().state as ProjectSuccess).result.data;
    currentProjectIndex = projects.indexWhere((e) => e.isCurrent);
    bloc = context.read<HistoryUserSupportRequestBloc>();
    bloc2 = context.read<ProjectUserSupportBloc>().state;
    selectProperties = (bloc2 as ProjectUserSupportSelect).projectSelect;
    bloc.add(HistoryUserSupportRequestLoaded(
        apiKey: projects[currentProjectIndex].inmobiliaria!.pvi![0].apikey!,
        dni: user.dni!,
        idProyecto: selectProperties.producto!.idGci!,
        idRequest: widget.id));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryUserSupportRequestBloc,
        HistoryUserSupportRequestState>(
      builder: (_, state) {
        if (state is HistoryUserSupportRequestSuccess) {
          if (state.result.data.isEmpty) {
            return ListView(
              shrinkWrap: true,
              children: const [
                SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  //padding: EdgeInsets.only(top: 150.h),
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
            );
          } else {
            requestList = state.result.data;

            return ListView.builder(
              shrinkWrap: true,
              itemCount: requestList.length,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (_, i) => RequirementsCard(
                request: requestList[i],
              ),
            );
          }
        } else if (state is HistoryUserSupportRequestFailure) {
          return Center(child: Text(state.result.message??''));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class RequirementsCard extends StatelessWidget {
  final UserSupportHistoryRequestModel request;

  const RequirementsCard({required this.request, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String i18n(String text) => FlutterI18n.translate(context, text);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Colors.black12.withOpacity(0.02),
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(i18n("form.Historial_Requerimiento"),
                style: _styles.regularText(14.sp, const Color(0xFF1D1D1D))),
            StatusRequest(request.estadoRequerimiento!)
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            const Icon(Icons.insert_drive_file),
            Text(request.folioRequerimiento ?? '',
                style: _styles.regularText(14.sp, const Color(0xFF1D1D1D)))
          ]),
          const SizedBox(
            height: 5,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text("F. Ultima Actualizacion: ",
                      style: _styles.regularText(12.sp, const Color(0xFF1D1D1D))),
                  Text(request.ultimaActualizacion?.split(" ")[0] ?? '',
                      style: _styles.regularText(12.sp, const Color(0xFF1D1D1D)))
                ]),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: 190.w,
                  child: Text(request.detalle ?? '',
                      textAlign: TextAlign.left,
                      maxLines: 3,
                      style: _styles.regularText(12.sp, const Color(0xFF1D1D1D))),
                ),
                const SizedBox(
                  height: 5,
                )
              ],
            ),
            Visibility(
              visible: false,
              child:
              Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                if (request.urgencia == "1")
                  const Icon(Icons.warning, color: Colors.deepOrange),
                if (request.criticidad != null)
                  const Icon(Icons.error, color: Colors.red),
                if (request.estadoGarantia != "VIGENTE")
                  const Icon(Icons.error, color: Colors.yellow),
              ]),
            ),
          ]),
          Text(
            i18n("form.Historial_Descripción"),
            textAlign: TextAlign.left,
            style: _styles.mediumText(14.sp, const Color(0xFF1D1D1D)),
          ),
          Text(
            request.descripcion ?? '',
            textAlign: TextAlign.left,
            style: _styles.regularText(14.sp, const Color(0xFF2F2F2F)),
          ),
          Row(
            children: [
              if (request.documentos != null &&
                  request.documentos!
                      .where((e) =>
                  RegExp(r"(png|jpg|jpeg|gif|BMP)$")
                      .stringMatch(e.url!) !=
                      null)
                      .isNotEmpty)
                IconButton(
                    icon: const Icon(
                      Icons.image,
                      color: Color(0xFF1D1D1D),
                    ),
                    onPressed: () =>
                        RequirementsCardDialog()
                            .openPostSaleDialogImage(context,
                            request.folioRequerimiento!, request.documentos!)),
              if (request.documentos != null &&
                  request.documentos!
                      .where((e) =>
                  RegExp(r"(pdf|doc|xls|prf)$").stringMatch(e.url!) !=
                      null)
                      .isNotEmpty)
                IconButton(
                    icon: const Icon(
                      CustomNewIcon.iconFile2,
                      color: Color(0xFF1D1D1D),
                    ),
                    onPressed: () =>
                        RequirementsCardDialog()
                            .openPostSaleDialogFile(context,
                            request.folioRequerimiento!, request.documentos!))
            ],
          ),
        ],
      ),
    );
  }
}
class StatusRequest extends StatelessWidget {
  final EstadoRequerimiento status;

  StatusRequest(this.status, {super.key});

  final colorText =const [
    Color(0xFF232C48),
    Color(0xFFFFBF2B),
    Color(0xFF47BC4C),
    Color(0xFFFF0018)
  ];
  final colorBackground = const[
    Color(0xFFE9E4DC),
    Color(0xFFFFF8E6),
    Color(0xFFCFFFD1),
    Color(0xFFFFE6E6)
  ];
  final icon = [
    Icons.access_time_rounded,
    Icons.check_circle_outline,
    Icons.check_circle_outline,
    Icons.cancel_outlined
  ];

  @override
  Widget build(BuildContext context) {
    final statusCode =
        int.parse(status.id ?? '0') >= 3 ? 2 : int.parse(status.id ?? '1') - 1;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colorBackground[statusCode],
      ),
      child: Row(
        children: [
          Icon(
            icon[statusCode],
            color: colorText[statusCode],
          ),
          const SizedBox(
            width: 2,
          ),
          Text(status.glosa??'',
              style: _styles.semiBoldText(12.sp, colorText[statusCode]))
        ],
      ),
    );
  }
}
