
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:iclavis/blocs/history_user_support_request/history_user_support_request_bloc.dart';
import 'package:iclavis/models/property_model.dart';
import 'package:iclavis/utils/Translation/name_utils.dart';
import 'package:iclavis/utils/extensions/download.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:iclavis/blocs/history_user_support/history_user_support_bloc.dart';
import 'package:iclavis/models/user_support_history_model.dart';
import 'package:iclavis/shared/shared.dart';
import 'package:iclavis/widgets/widgets.dart';

import 'request_history_card_requirement.dart';
import '../styles.dart';

final _styles = UserSupportViewsStyles();

class RequestHistoryCard extends StatefulWidget {
  final int historyIndex;
  final Producto? producto;

  RequestHistoryCard({super.key,
    required this.historyIndex,
    this.producto,
  });

  @override
  _RequestHistoryCardState createState() => _RequestHistoryCardState();
}

class _RequestHistoryCardState extends State<RequestHistoryCard>
    with SingleTickerProviderStateMixin {
  bool isPanelOpen = false;

  late List<UserSupportHistoryModel> history;

  @override
  void didChangeDependencies() {
    history = (context.read<HistoryUserSupportBloc>().state
            as HistoryUserSupportSuccess)
        .result
        .data;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    String i18n(String text) => FlutterI18n.translate(context, text);

    return BlocListener<HistoryUserSupportRequestBloc,
            HistoryUserSupportRequestState>(
        child: GestureDetector(
            child: Container(
              margin: EdgeInsets.only(bottom: 14.h),
              child: Card(
                elevation: 3,
                shape: _styles.cardCircularBorder(4.w),
                child: Column(
                  children: [
                    SizedBox(
                      height: 135.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _headerCard(
                              history[widget.historyIndex].tipoSolicitud ?? 0,
                              history[widget.historyIndex].estadoSolicitud!,
                              widget.producto!.nombre!,
                              context),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text("${i18n("form.Historial_Folio")}: ",
                                        style: _styles.regularText(14.sp)),
                                    Text(
                                        history[
                                                        widget.historyIndex]
                                                    .tipoSolicitud ==
                                                1
                                            ? history[widget.historyIndex]
                                                    .folio ??
                                                '00'
                                            : history[widget.historyIndex].id ??
                                                '00',
                                        style: _styles.lightText(
                                            14.sp, const Color(0xff1D1D1D))),
                                  ],
                                ),
                                SizedBox(
                                  height: 8.w,
                                ),
                                Row(
                                  children: [
                                    Text(i18n("form.Historial_Fecha_Inicio"),
                                        style: _styles.lightText(
                                            14.sp, const Color(0xFF2F2F2F))),
                                    Text(
                                        history[widget.historyIndex]
                                                .fechaInicio
                                                ?.split(' ')[0] ??
                                            '',
                                        style: _styles.lightText(
                                            14.sp, const Color(0xFF2F2F2F))),
                                  ],
                                ),
                                if (history[widget.historyIndex]
                                            .tipoSolicitud ==
                                        1 &&
                                    history[widget.historyIndex].fechaCierre !=
                                        null)
                                  Row(
                                    children: [
                                      Text(i18n("form.Historial_Fecha_Cierre"),
                                          style: _styles.lightText(
                                              14.sp, const Color(0xFF2F2F2F))),
                                      Text(
                                          history[widget.historyIndex]
                                                  .fechaCierre ??
                                              '',
                                          style: _styles.lightText(
                                              14.sp, const Color(0xFF2F2F2F))),
                                    ],
                                  ),
                                if (history[widget.historyIndex]
                                        .tipoSolicitud ==
                                    0)
                                  SizedBox(
                                    height: 5.w,
                                  ),
                                if (history[widget.historyIndex]
                                            .tipoSolicitud ==
                                        0 &&
                                    history[widget.historyIndex].documento !=
                                        null)
                                  ViewDocument(
                                    documento:
                                        history[widget.historyIndex].documento!,
                                    folio: history[widget.historyIndex].folio!,
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5.w,
                          ),
                          TextOpenCard(
                            isPanelOpen: isPanelOpen,
                            type: history[widget.historyIndex].tipoSolicitud!,
                            history: history[widget.historyIndex],
                          ),
                        ],
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 10),
                      child: Visibility(
                        visible: isPanelOpen,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 20.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Divider(
                                thickness: 1,
                              ),
                              if (history[widget.historyIndex].tipoSolicitud ==
                                  0)
                                Column(
                                  children: [
                                    Container(
                                        padding: EdgeInsets.only(
                                            top: 2.h, bottom: 2.h),
                                        width: double.infinity,
                                        child: Text(
                                          i18n("form.Historial_Descripción"),
                                          textAlign: TextAlign.left,
                                          style: _styles.mediumText(
                                              14.sp, const Color(0xFF2F2F2F)),
                                        )),
                                    Container(
                                      padding: EdgeInsets.only(
                                          top: 2.h, bottom: 2.h),
                                      width: double.infinity,
                                      child: Text(
                                        history[widget.historyIndex]
                                                .descripcion ??
                                            'Sin descripción',
                                        textAlign: TextAlign.left,
                                        style: _styles.lightText(
                                            14.sp, const Color(0xFF2F2F2F)),
                                      ),
                                    ),
                                  ],
                                ),
                              if (history[widget.historyIndex].tipoSolicitud ==
                                  1)
                                RequestHistoryCardList(
                                  history[widget.historyIndex].id!,
                                ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Visibility(
                                          visible: isPanelOpen,
                                          child: const Icon(Icons.keyboard_arrow_up)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              setState(() {
                isPanelOpen = !isPanelOpen;
              });
            }),
        listener: (_, state) {
          if (state is HistoryUserSupportRequestSuccess) {
            if (state.result.data[0].idSolicitud !=
                history[widget.historyIndex].id) {
              setState(() {
                isPanelOpen = false;
              });
            }
          }
        });
  }

  Widget _headerCard(int type, EstadoSolicitud status, String propiedad,
      BuildContext context) {
    String i18n(String text) => FlutterI18n.translate(context, text);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(type == 0
                  ? CustomIcons.i_historial_solicitudes
                  : CustomIcons.i_consulta),
              SizedBox(
                width: 5.w,
              ),
              Text(
                  type == 0
                      ? i18n("form.Historial_Consulta_Titulo")
                      : i18n("form.Historial_Postventa_Titulo"),
                  style: _styles.regularText(14.sp, const Color(0xff1D1D1D))),
            ],
          ),
          StatusRequest(status),
          Text(NameUtil.shortName(propiedad),
              style: _styles.regularText(14.sp, const Color(0xff1D1D1D))),
        ],
      ),
    );
  }
}

class TextOpenCard extends StatelessWidget {
  final bool isPanelOpen;
  final int type;
  final UserSupportHistoryModel history;

  TextOpenCard({super.key, required this.isPanelOpen, required this.type, required this.history});

  @override
  Widget build(BuildContext context) {
    String i18n(String text) => FlutterI18n.translate(context, text);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (type == 0)
                SizedBox(
                  width: 260.w,
                  child: Text(history.categoriaConsulta ?? 'Detalles',
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      style: _styles.mediumText(13.sp)),
                )
              else
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffe9e4dc),
                      ),
                      child: Center(
                        child: Text(
                          history.cantidadDeRequerimientos?.toString() ?? '0',
                          style: _styles.mediumText(10.sp, const Color(0xFF2F2F2F)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(i18n("form.Historial_Requerimiento"),
                        style: _styles.mediumText(14.sp, const Color(0xFF1D1D1D))),
                  ],
                ),
              //if(type==0 || type!=0 &&  history.cantidadDeRequerimientos?.toString()!="0")
              Visibility(
                  visible: !isPanelOpen,
                  child: Icon(isPanelOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down_outlined)),
            ],
          ),
        ],
      ),
    );
  }
}

class StatusRequest extends StatelessWidget {
  final EstadoSolicitud status;

  StatusRequest(this.status, {super.key});

  final colorText = const[
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
        int.parse(status.id ?? '1') >= 4 ? 3 : int.parse(status.id ?? '1') - 1;
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
          Text(status.glosa ?? '',
              style: _styles.semiBoldText(12.sp, colorText[statusCode]))
        ],
      ),
    );
  }
}

class ViewDocument extends StatelessWidget {
  final String folio;
  final List<Documento> documento;
  const ViewDocument({super.key, required this.folio, required this.documento});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openPostSaleDialog(context, folio, documento),
      child: Row(
        children: [
          const Icon(Icons.insert_drive_file),
          Text(
            "Ver Documentos",
            style: _styles.regularText(14.sp).copyWith(
                  decoration: TextDecoration.underline,
                ),
          )
        ],
      ),
    );
  }

  void openPostSaleDialog(
      BuildContext globalContext, String folio, List<Documento> documento) {
    FocusScope.of(globalContext).requestFocus(FocusNode());

    showDialog(
      context: globalContext,
      builder: (BuildContext context) => PostSaleDialog(
          height: 350,
          title: "Documentos",
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text("Folio:$folio", style: _styles.regularText(14.sp)),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: documento.length,
                      itemBuilder: (context, i) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.insert_drive_file,
                                color: Color(0xFF2F2F2F),
                              ),
                              Text(documento[i].nombre??'',
                                  style: _styles.regularText(
                                      14.sp, const Color(0xFF2F2F2F))),
                              IconButton(
                                  icon: const Icon(Icons.file_download),
                                  onPressed: () {
                                    DownloadUtil().download(
                                        documento[i].url??'', documento[i].nombre??'');
                                  })
                            ],
                          ))
                ],
              ))),
    );
  }
}