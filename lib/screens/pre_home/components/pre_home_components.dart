import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iclavis/blocs/contacts/contacts_bloc.dart';

import 'package:iclavis/blocs/history_user_support/history_user_support_bloc.dart';
import 'package:iclavis/blocs/notification/notification_bloc.dart';
import 'package:iclavis/blocs/payment/payment_bloc.dart';
import 'package:iclavis/blocs/project/project_bloc.dart';
import 'package:iclavis/blocs/property/property_bloc.dart';
import 'package:iclavis/models/project_model.dart';
import 'package:iclavis/routes/routes.dart';
import 'package:iclavis/widgets/widgets.dart';

import 'styles.dart';

final _styles = PreHomeStyles();

class PreHomeComponents extends StatefulWidget {
  const PreHomeComponents({Key? key}) : super(key: key);

  @override
  _PreHomeComponentsState createState() => _PreHomeComponentsState();
}

class _PreHomeComponentsState extends State<PreHomeComponents>
    with SingleTickerProviderStateMixin {
  CarouselController? carouselController;
  AnimationController? controller;

  late List<ProjectModel> projects;
  int currentPage = 0;

  @override
  void initState() {
    carouselController = CarouselController();
    controller = AnimationController(
      vsync: this,
    );

    super.initState();
  }

  @override
  void didChangeDependencies() {
    projects =
        (context.read<ProjectBloc>().state as ProjectSuccess).result.data;

    if (projects != null) {
      currentPage = projects.indexWhere((p) => p.isCurrent);

      if (currentPage == -1) {
        currentPage = 0;
      }
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 30.h,
      ),
      child: CarouselSlider.builder(
        carouselController: carouselController,
        options: CarouselOptions(
          initialPage: currentPage,
          height: 501.h,
          viewportFraction: .7,
          enlargeCenterPage: true,
          disableCenter: true,
          enableInfiniteScroll: false,
          onPageChanged: (i, _) {
            setState(() {
              currentPage = i;
            });
          },
          onScrolled: (i) {
            controller?.value = (currentPage - i!).abs();
          },
        ),
        itemCount: projects.length,
        itemBuilder: (_, i, option) => Column(
          children: [
            GestureDetector(
              child: CachedNetworkImage(
                imageUrl: projects[i].proyecto?.gci?.logo ?? '',
                width: 280.w,
                height: 396.h,
                imageBuilder: (_, image) {
                  return Card(
                    elevation: 3,
                    child: ClipRRect(
                      borderRadius: _styles.imageBorderRadius,
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: image,
                          fit: BoxFit.contain,
                        )),
                      ),
                    ),
                  );
                },
                errorWidget: (_, url, __) {
                  return const EmptyImage();
                },
              ),
              onTap: () =>
                  goToHome(projects[i].proyecto?.gci?.id ?? 0, projects[i]),
            ),
            Container(
              width: 200.w,
              margin: EdgeInsets.only(
                top: 27.h,
              ),
              child: GestureDetector(
                child: FadedTitle(
                  controller: controller!,
                  isEnabled: i == currentPage ? true : false,
                  title: projects[i].proyecto?.gci?.glosa ?? '',
                ),
                onTap: () =>
                    goToHome(projects[i].proyecto?.gci?.id ?? 0, projects[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void goToHome(int id, [ProjectModel? project]) {
    context
      ..read<ProjectBloc>().add(CurrentProjectSaved(id: id))
      ..read<PropertyBloc>().add(PropertyChanged())
      ..read<PaymentBloc>().add(PaymentAccountChanged())
      ..read<ContactsBloc>().add(ContactsChanged())
      ..read<HistoryUserSupportBloc>().add(HistoryUserSupportChanged())
      ..read<NotificationBloc>().add(NotificationChanged());
    NotificationBloc.projectId = id;

    FirebaseAnalytics.instance.logEvent(name: 'select_project', parameters: {
      'proyectoId': project?.proyecto?.gci?.id,
      'proyectoGlosa': project?.proyecto?.gci?.glosa,
      'inmobiliaria': projects.first.inmobiliaria?.gci?.id,
    });
    GoRouter.of(context).pushReplacementNamed(
        RouteName.Home);
  }
}

class FadedTitle extends StatelessWidget {
  final AnimationController controller;
  final bool isEnabled;
  final String title;

  FadedTitle({
    Key? key,
    required this.controller,
    required this.isEnabled,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(
        begin: isEnabled ? 1.0 : 0.0,
        end: 0.0,
      ).animate(controller),
      child: SizedBox(
        width: 285.w,
        height: 66.h,
        child: AutoSizeText(
          title,
          style: _styles.lightText(24.sp, const Color(0xff463E40)),
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      ),
    );
  }
}
