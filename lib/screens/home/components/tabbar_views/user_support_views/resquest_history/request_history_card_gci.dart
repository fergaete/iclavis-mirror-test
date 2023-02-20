import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:iclavis/blocs/history_user_support_gci/history_user_support_gci_bloc.dart';
import 'package:iclavis/models/user_support_history_gci_model.dart';

import '../../user_support_views/styles.dart';

final _styles = UserSupportViewsStyles();

class RequestHistoryCardGci extends StatefulWidget {
  final int historyIndex;

  RequestHistoryCardGci({
    Key? key,
    required this.historyIndex,
  }) : super(key: key);

  @override
  _RequestHistoryCardGciState createState() => _RequestHistoryCardGciState();
}

class _RequestHistoryCardGciState extends State<RequestHistoryCardGci>
    with SingleTickerProviderStateMixin {
  bool isPanelOpen = false;

  late List<UserSupportHistoryGciModel> history;

  @override
  void didChangeDependencies() {
    history = (context.read<HistoryUserSupportGciBloc>().state
            as HistoryUserSupportGciSuccess)
        .result
        .data;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.only(bottom: 14.h),
          child: Card(
            elevation: 3,
            shape: _styles.cardCircularBorder(4.w),
            child: Column(
              children: [
                SizedBox(
                  height: 123.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                history[widget.historyIndex]
                                        .tipoConsulta
                                        ?.glosa ??
                                    '',
                                style: _styles.mediumText(14.sp),
                                maxLines: 1,
                                textScaleFactor: 1.0),
                            Text(
                              DateFormat("dd/MM/yyyy").format(
                                  history[widget.historyIndex]
                                      .tipoConsulta!
                                      .fechaCreacion!),
                              style: _styles.regularText(14.sp),
                              maxLines: 1,
                              textScaleFactor: 1.0,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 240.w,
                              child: Text(
                                history[widget.historyIndex]
                                        .tipoConsulta
                                        ?.categoria
                                        ?.glosa ??
                                    '',
                                style: _styles.lightText(14.sp),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textScaleFactor: 1.0,
                              ),
                            ),
                            Text(
                              history[widget.historyIndex].producto?.nombre ??
                                  '',
                              style: _styles.mediumText(14.sp),
                              maxLines: 1,
                              textScaleFactor: 1.0,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 0),
                  vsync: this,
                  child: Visibility(
                    visible: isPanelOpen,
                    child: SizedBox(
                      width: 287.w,
                      child: Column(
                        children: [
                          const Divider(
                            thickness: 1,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 18.5.h,
                              bottom: 17.h,
                            ),
                            child: Text(
                              history[widget.historyIndex]
                                      .tipoConsulta
                                      ?.consulta ??
                                  '',
                              style: _styles.lightText(14.sp),
                            ),
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
        });
  }
}
