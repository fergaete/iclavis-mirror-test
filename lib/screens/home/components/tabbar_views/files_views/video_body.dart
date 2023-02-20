import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chewie/chewie.dart';
import 'package:iclavis/blocs/user/user_bloc.dart';
import 'package:iclavis/personalizacion.dart';
import 'package:iclavis/widgets/empty_card/widget.dart';
import 'package:iclavis/widgets/modal_overlay/widget.dart';
import 'package:video_player/video_player.dart';

import 'package:iclavis/blocs/project/project_bloc.dart';
import 'package:iclavis/models/project_model.dart';
import 'package:iclavis/blocs/video/video_bloc.dart';
import 'package:iclavis/models/video_model.dart';
import 'package:iclavis/shared/shared.dart';

final _styles = TextStylesShared();

List<String> _videoUrlList = [];

class VideosBody extends StatefulWidget {
  const VideosBody({super.key});

  @override
  State<VideosBody> createState() => _VideosBodyState();
}

class _VideosBodyState extends State<VideosBody>
    with AutomaticKeepAliveClientMixin {
  bool isPreviewPlayeded = true;

  @override
  void didChangeDependencies() {
    final videoBloc = context.read<VideoBloc>();

    final userState = context.read<UserBloc>().state;
    final projectState = context.read<ProjectBloc>().state;

    if (userState is UserSuccess && projectState is ProjectSuccess) {
      final currentProject = (projectState.result.data as List<ProjectModel>)
          .firstWhere((e) => e.isCurrent);

      if (videoBloc.state is! VideoSuccess) {
        videoBloc.add(
          VideoLoaded(
            dni: userState.user.dni!,
            apiKey: currentProject.inmobiliaria!.gci!.apikey!,
            idProyecto: currentProject.proyecto!.gci!.id!,
          ),
        );
      }
    }
    /* final videoBloc = context.read<VideoBloc>();

    if (videoBloc.state is! VideoSuccess) {
      videoBloc.add(VideoLoaded());
    } */

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    String i18n(String text) => FlutterI18n.translate(context,text);

    return BlocConsumer<VideoBloc, VideoState>(
      listener: (_, state) {
        if (state is VideoFailure) {
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
        if (state is VideoSuccess) {
          final List<VideoModel> videos = state.result.data;

          if (_videoUrlList.isNotEmpty) {
            _videoUrlList.removeWhere((_) => true);
          }

          videos.forEach((e) {
            _videoUrlList.add(e.url??'');
          });

          if (videos.isEmpty) {
            return Align(
              alignment: Alignment.topCenter,
              child: EmptyCard(
                text:  i18n("archive.empty_videos"),
                svg: 'assets/images/empty_image.svg',
              ),
            );
          }

          return ListView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: videos.length,
            itemBuilder: (_, i) => GestureDetector(
              child: VideoPreview(
                video: videos[i].url??'',
              ),
              onTap: () => openFullscreenVideo(context,videos[i].url??''),
            ),
          );
        } else if (state is VideoFailure) {
          return Center(
            child: Text(state.result.message??''),
          );
        } else {
          return const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void openFullscreenVideo(BuildContext context,String videoUrl) {
    String i18n(String text) => FlutterI18n.translate(context,text);
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: GestureDetector(
              child: Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Icon(
                  CustomIcons.i_volver_atras,
                  size: 15.5.w,
                  color: Customization.variable_2,
                ),
              ),
              onTap: () => Navigator.pop(context),
            ),
            title: Text(
              i18n("archive.tag_videos"),
              style: _styles.lightText(18.sp, const Color(0xff121212)),
            ),
            centerTitle: true,
          ),
         body: CustomVideoPlayer(videoUrl: videoUrl,),
         // body: VideoCarrousel(),
        );
      },
      fullscreenDialog: true,
    ));
  }

  @override
  bool get wantKeepAlive => true;
}

class VideoPreview extends StatefulWidget {
  final String video;

  const VideoPreview({
    Key? key,
    required this.video,
  }) : super(key: key);

  @override
  _VideoPreviewState createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  late VideoPlayerController videoController;

  late String projectName;

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
  void didChangeDependencies() {
    final projectState = context.read<ProjectBloc>().state;

    if (projectState is ProjectSuccess) {
      projectName = (projectState.result.data as List<ProjectModel>)
          .where((e) => e.isCurrent)
          .first
          .proyecto!.gci!.glosa!;
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(17.w, 0, 17.w, 64.h),
      child: videoController.value.isInitialized
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.w),
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: videoController.value.aspectRatio,
                        child: VideoPlayer(videoController),
                      ),
                      const VideoMask(),
                      Positioned(
                        bottom: 13.h,
                        right: 19.w,
                        child: Container(
                          width: 54.w,
                          height: 20.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xff121212).withOpacity(.6),
                            borderRadius: BorderRadius.circular(8.w),
                          ),
                          child: Text(
                            videoController.value.duration.toString().replaceAll('.', ''),
                            style: _styles.mediumText(14.sp, Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 14.h,
                  ),
                  child: Text(
                    projectName ,
                    style: _styles.regularText(
                      12.sp,
                      const Color(0xff2f2f2f),
                    ),
                  ),
                ),
              ],
            )
          : const Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class CustomVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const CustomVideoPlayer({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController videoController;
  late ChewieController chewieController;

  @override
  void initState() {
    videoController = VideoPlayerController.network(widget.videoUrl)
      ..addListener(() {
        setState(() {});
      });

    chewieController = ChewieController(
      videoPlayerController: videoController,
      aspectRatio: 3 / 2,
      autoInitialize: true,
      allowMuting: false,
      errorBuilder: (_, e) => Center(
        child: Text(e),
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    videoController.dispose();
    chewieController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(17.w, 0, 17.w, 64.h),
        child: videoController.value.isInitialized
            ? ClipRRect(
                borderRadius: BorderRadius.circular(4.w),
                child: Chewie(
                  controller: chewieController,
                ))
            : const Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ));
  }
}

class VideoMask extends StatefulWidget {
  const VideoMask({Key? key}) : super(key: key);

  @override
  _VideoMaskState createState() => _VideoMaskState();
}

class _VideoMaskState extends State<VideoMask> {
  late String projectName;

  @override
  void didChangeDependencies() {
    final projectState = context.read<ProjectBloc>().state;

    if (projectState is ProjectSuccess) {
      projectName = (projectState.result.data as List<ProjectModel>)
          .where((e) => e.isCurrent)
          .first
          .proyecto!.gci!.glosa!;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 193.w,
      height: 25.h,
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(4.w),
          bottomRight: Radius.circular(4.w),
        ),
        shape: BoxShape.rectangle,
        color: const Color(0xff121212).withOpacity(.57),
      ),
      child: Text(
        projectName,
        style: _styles.regularText(12.sp, Colors.white),
      ),
    );
  }
}

class VideoCarrousel extends StatefulWidget {
  VideoCarrousel({Key? key}) : super(key: key);

  @override
  _VideoCarrouselState createState() => _VideoCarrouselState();
}

class _VideoCarrouselState extends State<VideoCarrousel>
    with SingleTickerProviderStateMixin {
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      children: _videoUrlList
          .map((e) => CustomVideoPlayer(
                videoUrl: e,
              ))
          .toList(),
    );
  }
}
