import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'package:iclavis/blocs/project/project_bloc.dart';
import 'package:iclavis/models/project_model.dart';
import 'package:iclavis/personalizacion.dart';
import 'package:iclavis/shared/custom_icons.dart';
import 'package:iclavis/shared/textstyles_shared.dart';
import 'package:iclavis/utils/extensions/analytics.dart';
import 'package:iclavis/widgets/widgets.dart';
import 'package:iclavis/routes/route_paths.dart';

final _styles = TextStylesShared();

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final int position;
  final Configuraciones? config;

  HomeAppBar({
    Key? key,
    required this.scaffoldKey,
    required this.position,
    this.config
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return CustomSizeAppBar(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 56.h,
        leading: IconButton(
          icon: Icon(
            CustomIcons.i_menu,
            color: Customization.variable_2,
            size: 30.w,
          ),
          onPressed: () {
            Analytics().addEventUserProject(
                name: 'boton_secundario', context: context);
            scaffoldKey.currentState?.openDrawer();
          },
        ),
        centerTitle: true,
        title: AppBarTitle(
          position: positionConfig(position),
        ),
      ),
    );
  }
  int positionConfig(int position){
    if(!config!.poseePagos && position>=2){
      return ++position;
    }
    return position;
  }
}

class AppBarTitle extends StatefulWidget {
  final int position;

  const AppBarTitle({Key? key, required this.position}) : super(key: key);

  @override
  _AppBarTitleState createState() => _AppBarTitleState();
}

class _AppBarTitleState extends State<AppBarTitle> {
  late String projectImage;
  late String inmobiliariaImage;
  bool hasOnlyOneProject = false;

  @override
  void didChangeDependencies() {
    final projectState = context.read<ProjectBloc>().state;

    if (projectState is ProjectSuccess) {
      final projects = (projectState.result.data as List<ProjectModel>);

      if (projects.length == 1) {
        hasOnlyOneProject = true;
      }

      projectImage =
          projects.where((e) => e.isCurrent).first.proyecto!.gci!.logo!;

      inmobiliariaImage =
          projects.where((e) => e.isCurrent).first.inmobiliaria!.gci!.logo!;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    String i18n(String text) => FlutterI18n.translate(context, text);
    switch (widget.position) {
      case 1:
        return Text(i18n("archive.my_file_title"),
            style: _styles.lightText(18.sp));
      case 2:
        return Text(i18n("payments.my_payments_title"),
            style: _styles.lightText(18.sp));
      case 3:
        return Text(i18n("form.my_requests_title"),
            style: _styles.lightText(18.sp));
      case 4:
        return Text(i18n("notification.my_notifications_title"),
            style: _styles.lightText(18.sp));
      default:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 28.w),
              child: CachedNetworkImage(
                imageUrl: inmobiliariaImage,
                imageBuilder: (_, image) {
                  return Container(
                    width: 180.w,
                    height: 45.h,
                    margin: EdgeInsets.all(5.h),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: image,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  );
                },
                errorWidget: (_, url, __) {
                  return Container();
                },
              ),
            ),
            IgnorePointer(
              ignoring: hasOnlyOneProject,
              child: GestureDetector(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: 40.h,
                      width: 40.h,
                      child: CachedNetworkImage(
                        imageUrl: projectImage,
                        imageBuilder: (_, image) {
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: image,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          );
                        },
                        errorWidget: (_, url, __) {
                          return Image.asset(
                            'assets/images/default_profile_image.png',
                          );
                        },
                      ),
                    ),
                  ),
                  onTap: () {
                    Analytics().addEventUserProject(
                        name: 'logo_proyecto', context: context);
                    Navigator.popAndPushNamed(context, RoutePaths.PreHome);
                  }),
            ),
          ],
        );
    }
  }
}
