import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iclavis/blocs/notification/notification_bloc.dart';
import 'package:iclavis/blocs/project/project_bloc.dart';
import 'package:iclavis/blocs/user/user_bloc.dart';
import 'package:iclavis/models/project_model.dart';
import 'package:iclavis/widgets/empty_image/widget.dart';
import 'package:video_player/video_player.dart';

import 'package:iclavis/routes/routes.dart';
import 'package:iclavis/shared/custom_icons.dart';

import 'styles.dart';

final _styles = NotificationsViewsStyles();

class AttachmentImage extends StatelessWidget {
  final String? image;
  final int notificationId;

  const  AttachmentImage(
      {Key? key,  this.image, required this.notificationId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TapWrapper(
      route: RoutePaths.FilesImage,
      notificationId: notificationId,
      child: Container(
        width: 300.w,
        height: 110.h,
        margin: EdgeInsets.only(top: 13.h, bottom: 4.h),
        decoration: _styles.imageDecoration,
        child: image != null
            ? CachedNetworkImage(
          imageUrl: image??'',
          placeholder: (_, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (_, url, __) {
            return EmptyImage(
              innerPadding: 15.h,
            );
          },
          fadeOutDuration: const Duration(),
          fit: BoxFit.contain,
        )
            : const NoAvailable(message: 'No Image Available'),
      ),
    );
  }
}

class AttachmentDocument extends StatelessWidget {
  final String document;
  final int notificationId;
  const AttachmentDocument(
      {Key? key, required this.document, required this.notificationId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TapWrapper(
      route: RoutePaths.Files,
      notificationId: notificationId,
      child: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(top: 26.h, bottom: 4.h),
        child: Icon(
          CustomIcons.i_documento_cerrado,
          size: 51.w,
        ),
      ),
    );
  }
}

class AttachmentVideo extends StatefulWidget {
  final String video;
  final int notificationId;

  const AttachmentVideo(
      {Key? key, required this.video, required this.notificationId})
      : super(key: key);

  @override
  _AttachmentVideoState createState() => _AttachmentVideoState();
}

class _AttachmentVideoState extends State<AttachmentVideo>
    with AutomaticKeepAliveClientMixin {
   VideoPlayerController? videoController;

  @override
  void initState() {
    videoController = VideoPlayerController.network(widget.video)
      ..initialize()
      ..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  void dispose() {
    videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: EdgeInsets.only(top: 19.h, bottom: 4.h),
      child: videoController!.value.isInitialized
          ? TapWrapper(
        route: RoutePaths.FilesVideo,
        notificationId: widget.notificationId,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4.w),
          child: AspectRatio(
            aspectRatio: videoController!.value.aspectRatio,
            child: widget.video != null
                ? VideoPlayer(videoController!)
                : const NoAvailable(message: 'No Video Available'),
          ),
        ),
      )
          : Center(
        child: SizedBox(
          width: 50.w,
          height: 50.w,
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class TapWrapper extends StatelessWidget {
  final Widget child;
  final String route;
  final int notificationId;

  const TapWrapper(
      {Key? key,
        required this.child,
        required this.route,
        required this.notificationId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: child,
        onTap: () {
          readNotification(context, notificationId);
          Navigator.pushReplacementNamed(context, route);
        });
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
}

class NoAvailable extends StatelessWidget {
  final String message;

  const NoAvailable({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error),
        Text(
          message,
          style: _styles.mediumText(12.sp),
          textScaleFactor: 1.0,
        )
      ],
    );
  }
}
