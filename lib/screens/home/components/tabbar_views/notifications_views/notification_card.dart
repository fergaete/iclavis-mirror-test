import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/blocs/notification/notification_bloc.dart';
import 'package:iclavis/blocs/project/project_bloc.dart';
import 'package:iclavis/blocs/user/user_bloc.dart';
import 'package:iclavis/models/notification_model.dart';
import 'package:iclavis/models/project_model.dart';
import 'package:iclavis/personalizacion.dart';
import 'package:url_launcher/url_launcher.dart';

import 'styles.dart';

final _styles = NotificationsViewsStyles();

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final Widget? attachment;

  const NotificationCard({
    Key? key,
    this.attachment,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      child: GestureDetector(
        onTap: (){
          if(attachment==null){
            readNotification(context,notification.id);
          }
        },
        child: Card(
          elevation: 3,
          shape: _styles.cardCircularBorder(4.w),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if(notification.isOpen==0)
                      Row(
                        children: [
                          Container(
                            width: 10.sp,
                            height: 10.sp,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.sp),
                                color: Customization.variable_1
                            ),
                          ),
                          const SizedBox(width: 5,),
                        ],
                      ),
                    SizedBox(
                      width: 170.sp,
                      child: Text(
                        notification.title??'',
                        style: _styles.mediumText(14.sp),
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    Expanded(

                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 15.w,
                            ),
                            const SizedBox(width: 5,),
                            Text(
                              parseCreatedAtToDate(notification.createdAt!),
                              style: _styles.lightText(14.sp),
                              maxLines: 1,
                              textScaleFactor: 1.0,
                            ),
                          ],
                        ))
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                SizedBox(
                    width: 296.w,
                    child: Linkify(
                      onOpen: (link) async {
                        if (!await launchUrl(Uri.parse(link.url))) {
                          throw 'Could not launch $link.url';
                        }
                      },
                      text: notification.message!.replaceAll('&amp;', ''),
                      textScaleFactor: 1.0,
                      style: _styles.lightText(14.sp),
                    )
                ),
                attachment ?? Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void readNotification (BuildContext context, int notificationId){
    final user = (context.read<UserBloc>().state as UserSuccess).user;


    context.read<NotificationBloc>().add(NotificationReadEvent(
        dni: user.dni!, notificacionId: notificationId));

    final bloc = context.read<NotificationBloc>();
    List<ProjectModel> projects =
        (context.read<ProjectBloc>().state as ProjectSuccess).result.data;
    final currentProject = projects.firstWhere((e) => e.isCurrent);
    bloc.add(NotificationHistoryLoaded(
      dni: user.dni!,
      projectId: currentProject.proyecto!.gci!.id!,
      apiKey: currentProject.inmobiliaria!.gci!.apikey!,
    ));

  }

  String parseCreatedAtToDate(DateTime createdAt) {
    final diff = DateTime.now().difference(createdAt);

    if (diff.inMinutes.range(1, 60)) {
      return "Hace ${diff.inMinutes} min";
    } else if (diff.inHours.range(0, 24)) {
      return "Hace ${diff.inHours} hrs";
    } else if (diff.inDays.range(0, 7)) {
      return "Hace ${diff.inDays} días";
    } else if (diff.inDays >= 7) {
      return "Hace ${(diff.inDays / 7).truncate()} sem";
    } else {
      return 'Ahora';
    }
  }
}

extension RangeDate on int {
  bool range(int start, int end) =>
      (this >= start && this < end) ? true : false;
}
