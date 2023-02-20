import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/blocs/notification/notification_bloc.dart';
import 'package:iclavis/blocs/project/project_bloc.dart';
import 'package:iclavis/blocs/user/user_bloc.dart';
import 'package:iclavis/models/notification_model.dart';
import 'package:iclavis/models/project_model.dart';
import 'package:iclavis/models/user_model.dart';
import 'package:iclavis/utils/Translation/translation_extension.dart';
import 'package:iclavis/widgets/widgets.dart';

import 'attachments.dart';
import 'notification_card.dart';
import 'styles.dart';

final _styles = NotificationsViewsStyles();

List<NotificationModel> _notifications = [];

Map<String, List<NotificationModel>> _notificationGrouped = {};

class NotificationsViews extends StatefulWidget {
  const NotificationsViews({super.key});

  @override
  State<NotificationsViews> createState() => _NotificationsViewsState();
}

class _NotificationsViewsState extends State<NotificationsViews>
    with AutomaticKeepAliveClientMixin {
  late UserModel user;
  late NotificationBloc bloc;
  late ProjectModel currentProject;

  @override
  void didChangeDependencies() {
    user = (context.read<UserBloc>().state as UserSuccess).user;

    bloc = context.read<NotificationBloc>();

    if (bloc.state is NotificationInitial || bloc.state == null) {
      if(context.read<ProjectBloc>().state is ProjectSuccess){
        List<ProjectModel> projects =
            (context.read<ProjectBloc>().state as ProjectSuccess).result.data;
        currentProject = projects.firstWhere((e) => e.isCurrent);
      }

      bloc.add(NotificationHistoryLoaded(
        dni: user.dni!,
        projectId: currentProject.proyecto!.gci!.id!,
        apiKey: currentProject.inmobiliaria!.gci!.apikey!,
      ));
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    context.watch<NotificationBloc>();
    final projectsState = context.watch<ProjectBloc>().state;

    if (projectsState is ProjectSuccess) {
      List<ProjectModel> projects = projectsState.result.data;

      currentProject = projects.firstWhere((e) => e.isCurrent);
    }

    return RefreshIndicator(
      onRefresh: () async {
        bloc.add(
          NotificationHistoryLoaded(
            dni: user.dni!,
            projectId: currentProject.proyecto!.gci!.id!,
            apiKey: currentProject.inmobiliaria!.gci!.apikey!,
            hasRefresh: true,
          ),
        );
      },
      child: BlocConsumer<NotificationBloc, NotificationState>(
        listener: (_, state) {
          if (state is NotificationSuccess) {
            notificationOrder(state.result.data);
          } else if (state is NotificationFailure) {
            ModalOverlay(
              context: context,
              message: 'Parece que hay problemas con nuestro servidor.'
                  ' Aprovecha de despejar la mente e intenta más tarde.',
              title: '¡Ups!',
              buttonTitle: 'Entendido',
            );
          }
        },
        builder: (_, state) {
          if (state is NotificationSuccess || state is NotificationReadSuccess  ) {
            if(state is NotificationSuccess) {
              notificationOrder(state.result.data);
            }
            return _View(
              notificationGrouped: _notificationGrouped,
            );
          } else if (state is NotificationFailure) {
            return const Center(
              child: Text('An error has occurred'),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  notificationOrder(List<NotificationModel> notificationList){
    String i18n(String text) => FlutterI18n.translate(context, text);
    _notifications = notificationList;
    _notifications.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));

    _notificationGrouped = groupBy<NotificationModel, String>(
      _notifications,
          (n) {
        return DateTime.now().difference(n.createdAt!).inDays <= 7
            ? i18n("notification.this_week")
            : i18n("notification.this_month");
      },
    );
  }

  Map<T, List<S>> groupBy<S, T>(Iterable<S> values, T Function(S) key) {
    var map = <T, List<S>>{};
    for (var element in values) {
      (map[key(element)] ??= []).add(element);
    }
    return map;
  }

  @override
  bool get wantKeepAlive => true;
}

class _View extends StatelessWidget {
  final Map<String, List<NotificationModel>> notificationGrouped;

  const _View({Key? key, required this.notificationGrouped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _notifications.isEmpty
        ? ListView(
            shrinkWrap: true,
            children: [
              SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(top: 150.h),
                child: Align(
                  child: EmptyCard(
                    text: "notification.empty_notification".i18n,
                    icon: Icons.alarm,
                  ),
                ),
              ),
            ],
          )
        : ListView.builder(
            physics:
                const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
            itemCount: _notificationGrouped.length,
            itemBuilder: (_, g) {
              g = _notificationGrouped.length - g - 1;
              final items = _notificationGrouped.values.toList()[g];
              return Column(
                children: [
                  DateDivider(
                    text: _notificationGrouped.keys.toList()[g],
                  ),
                  ListView.builder(
                    itemCount: items.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (_, i) {
                      i = items.length - i - 1;
                      switch (items[i].type) {
                        case 'texto':
                          return NotificationCard(
                            notification: items[i],
                          );
                        case 'foto':
                          return NotificationCard(
                            notification: items[i],
                            attachment: AttachmentImage(
                                notificationId: items[i].id,
                                image: items[i].attachment.first.payload ??''),
                          );
                        case 'video':
                          return NotificationCard(
                            notification: items[i],
                            attachment: AttachmentVideo(
                                notificationId: items[i].id,
                                video: items[i].attachment.first.payload??''),
                          );
                        case 'documento':
                          return NotificationCard(
                            notification: items[i],
                            attachment: AttachmentDocument(
                                notificationId: items[i].id,
                                document: items[i].attachment.first.payload??''),
                          );
                      }
                      return Container();
                    },
                  ),
                ],
              );
            },
          );
  }
}

class DateDivider extends StatelessWidget {
  final String? text;

  const DateDivider({
    Key? key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      child: Text(
        text??'',
        style: _styles.mediumText(
          14.sp,
          Color(0xff353340),
        ),
      ),
    );
  }
}
