import 'package:flutter/material.dart';


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';

import 'package:iclavis/blocs/image/image_bloc.dart';
import 'package:iclavis/blocs/project/project_bloc.dart';
import 'package:iclavis/blocs/user/user_bloc.dart';
import 'package:iclavis/models/image_model.dart';
import 'package:iclavis/models/project_model.dart';
import 'package:iclavis/personalizacion.dart';
import 'package:iclavis/shared/shared.dart';
import 'package:iclavis/widgets/empty_card/widget.dart';
import 'package:iclavis/widgets/empty_image/widget.dart';
import 'package:iclavis/widgets/modal_overlay/widget.dart';

final _styles = TextStylesShared();

class ImageBody extends StatefulWidget {
  ImageBody({Key? key}) : super(key: key);

  @override
  ImageBodyState createState() => ImageBodyState();
}

class ImageBodyState extends State<ImageBody>
    with SingleTickerProviderStateMixin {
  late TabController photoController;

  int i = 0;

  @override
  void initState() {
    photoController = TabController(length: 5, vsync: this);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    final imageBloc = context.read<ImageBloc>();

    final userState = context.read<UserBloc>().state;
    final projectState = context.read<ProjectBloc>().state;

    if (userState is UserSuccess && projectState is ProjectSuccess) {
      final currentProject = (projectState.result.data as List<ProjectModel>)
          .firstWhere((e) => e.isCurrent);

      if (imageBloc.state is! ImageSuccess) {
        imageBloc.add(
          ImageLoaded(
            dni: userState.user.dni!,
            apiKey: currentProject.inmobiliaria!.gci!.apikey!,
            idProyecto: currentProject.proyecto!.gci!.id!,
          ),
        );
      }
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    photoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String i18n(String text) => FlutterI18n.translate(context,text);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 345.w,
          child: TabBar(
            controller: photoController,
            labelColor: const Color(0xff2F2F2F),
            indicatorColor: Colors.transparent,
            labelPadding: const EdgeInsets.symmetric(horizontal: 0),
            onTap: (indicator) => setState(() {
              i = indicator;
            }),
            tabs: [
              CustomPhotoTab(
                text: i18n("archive.tag_project") ,
                isActive: i == 0 ? true : false,
              ),
              CustomPhotoTab(
                text: i18n("archive.tag_progress"),
                isActive: i == 1 ? true : false,
              ),
              CustomPhotoTab(
                text: i18n("archive.tag_surroundings"),
                isActive: i == 2 ? true : false,
              ),
              CustomPhotoTab(
                text: i18n("archive.tag_display_house"),
                isActive: i == 3 ? true : false,
              ),
              CustomPhotoTab(
                text: i18n("archive.tag_others"),
                isActive: i == 4 ? true : false,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 17.h,
        ),
        Expanded(
          child: BlocConsumer<ImageBloc, ImageState>(
            listener: (_, state) {
              if (state is ImageFailure) {
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
              if (state is ImageSuccess) {

              List<ImageModel?>  images =  (state.result.data as List<ImageModel>);


                return TabBarView(
                  controller: photoController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    CustomPhotoGrid(
                      payload: images.firstWhereOrNull(
                          (e) =>
                              e!.categoryName!.toLowerCase().contains('proyecto'),),
                      title:'proyecto' ,
                    ),
                    CustomPhotoGrid(
                      payload: images.firstWhereOrNull(
                          (e) =>
                              e!.categoryName!.toLowerCase().contains('avance'),),
                      title:'avance' ,
                    ),
                    CustomPhotoGrid(
                      payload: images.firstWhereOrNull(
                          (e) =>
                              e!.categoryName!.toLowerCase().contains('entorno'),),
                      title:'entorno' ,
                    ),
                    CustomPhotoGrid(
                      payload: images.firstWhereOrNull(
                          (e) =>
                              e!.categoryName!.toLowerCase().contains('piloto'),),
                      title:'piloto' ,
                    ),
                    CustomPhotoGrid(
                      payload: images.firstWhereOrNull(
                          (e) => e!.categoryName!.toLowerCase().contains('otros'),),
                      title:'proyecto' ,
                    )
                  ],
                );
              } else if (state is ImageFailure) {
                return Center(
                  child: Text(state.result.message??''),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class CustomPhotoTab extends StatelessWidget {
  final String text;
  final bool isActive;

  const CustomPhotoTab({
    Key? key,
    required this.text,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          style: _styles.lightText(14.sp, Color(0xff121212)),
          maxLines: 1,
          textScaleFactor: 1.0,
        ),
        SizedBox(
          height: 5.h,
        ),
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: isActive == true
                ? Customization.variable_1
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
        )
      ],
    );
  }
}

class CustomPhotoGrid extends StatelessWidget {
  final ImageModel? payload;
  final String title;

  const CustomPhotoGrid({Key? key, this.payload,required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String i18n(String text) => FlutterI18n.translate(context,text);
    return payload == null
        ? Align(
            alignment: Alignment.topCenter,
            child: EmptyCard(
              text: i18n("archive.empty_images_$title"),
              svg: 'assets/images/empty_image.svg',
            ),
          )
        : GridView.count(
            crossAxisCount: 2,
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            children: List.generate(
              payload!.images!.length,
              (i) => GestureDetector(
                child: Card(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.w),
                    child: CachedNetworkImage(
                      imageUrl: payload!.images![i].url??'',
                      fit: BoxFit.fitHeight,
                      errorWidget: (_, url, __) {
                        return EmptyImage(
                          innerPadding: 12.h,
                        );
                      },
                    ),
                  ),
                ),
                onTap: () => openFullscreenPhoto(context, i),
              ),
            ),
          );
  }

  void openFullscreenPhoto(final context, int i) {
    String i18n(String text) => FlutterI18n.translate(context,text);
    Navigator.of(context).push(MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.black,
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
              i18n("archive.tag_photos"),
              style: _styles.lightText(18.sp, Color(0xff121212)),
            ),
            centerTitle: true,
          ),
          body: Center(
            child: GestureDetector(
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 0.2,
                maxScale: 6,
                child: SizedBox(
                  width: 326.w,
                  height: 547.h,
                  child: CachedNetworkImage(
                    imageUrl: payload!.images![i].url??'',
                    imageBuilder: (_, image) {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: image,
                            fit: BoxFit.fitWidth,
                          )
                        ),
                      );
                    },
                    errorWidget: (_, url, __) {
                      return EmptyImage(
                        innerPadding: 12.h,
                      );
                    },
                  ),
                ),
              ),
              onDoubleTap: () => Navigator.pop(context),
            ),
          ),
        );
      },
      fullscreenDialog: true,
    ));
  }
}
