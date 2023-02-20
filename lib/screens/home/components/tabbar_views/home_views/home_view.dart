import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iclavis/blocs/notification/notification_bloc.dart';

import 'package:iclavis/blocs/project/project_bloc.dart';
import 'package:iclavis/blocs/property/property_bloc.dart';
import 'package:iclavis/blocs/user/user_bloc.dart';
import 'package:iclavis/models/project_model.dart';
import 'package:iclavis/models/property_model.dart';
import 'package:iclavis/personalizacion.dart';
import 'package:iclavis/routes/route_paths.dart';
import 'package:iclavis/screens/home/components/home_drawer/drawer_faqs/drawer_faqs.dart';
import 'package:iclavis/services/user_storage/user_storage.dart';
import 'package:iclavis/utils/extensions/analytics.dart';
import 'package:iclavis/utils/validation/pvi_validator.dart';
import 'package:iclavis/widgets/widgets.dart';

import 'home_card.dart';
import 'home_news_card.dart';

class HomeViews extends StatefulWidget {
  const HomeViews({Key? key}) : super(key: key);

  @override
  _HomeViewsState createState() => _HomeViewsState();
}

class _HomeViewsState extends State<HomeViews> {
  @override
  void didChangeDependencies() {
    final propertyState = context.read<PropertyBloc>().state;

    if (propertyState is! PropertySuccess) {
      final user = (context.read<UserBloc>().state as UserSuccess).user;

      List<ProjectModel> projects =
          (context.read<ProjectBloc>().state as ProjectSuccess).result.data;

      var currentProject =
          projects.firstWhere((p) => p.isCurrent, orElse: () => projects.first);

      context.read<PropertyBloc>().add(PropertyLoaded(
            dni: user.dni!,
            id: currentProject.proyecto!.gci!.id!,
            apiKey: currentProject.inmobiliaria!.gci!.apikey!,
          ));
      context.read<NotificationBloc>().add(NotificationHistoryLoaded(
            dni: user.dni!,
            projectId: currentProject.proyecto!.gci!.id!,
            apiKey: currentProject.inmobiliaria!.gci!.apikey!,
          ));
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PropertyBloc, PropertyState>(
      listener: (_, state) {
        if (state is PropertyFailure) {
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
        if (state is PropertySuccess) {
          if ((state.result.data as PropertyModel).negocios!.isEmpty) {
            return const Center(
                child: Text('No hay propiedades para este proyecto'));
          }
          return const _View();
        } else if (state is PropertyFailure) {
          return Center(child: Text(state.result.message ?? ''));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class _View extends StatefulWidget {
  const _View({Key? key}) : super(key: key);

  @override
  __ViewState createState() => __ViewState();
}

class __ViewState extends State<_View> {
  late ProjectModel currentProject;
  late PropertyModel property;
  late int currentPropertyIndex;
  @override
  void didChangeDependencies() {
    PropertyBloc propertyBloc = context.read<PropertyBloc>();
    property = (propertyBloc.state as PropertySuccess).result.data;

    currentPropertyIndex = property.negocios!.indexWhere((p) => p.isCurrent!);

    List<ProjectModel> projects =
        (context.read<ProjectBloc>().state as ProjectSuccess).result.data;

    currentProject =
        projects.firstWhere((p) => p.isCurrent, orElse: () => projects.first);
    if (currentPropertyIndex == -1) {
      currentPropertyIndex = 0;
    }

    super.didChangeDependencies();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!await UserStorage().readAlet() &&
          (currentProject.proyecto!.pvi!.id != null &&
              currentProject.inmobiliaria!.pvi![0].id != null)) {
        openPostSaleDialog();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String i18n(String text) => FlutterI18n.translate(context, text);

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 66.h),
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          const HomeCard(),
          if (PviValidator().typeProject(
                  currentProject, property.negocios![currentPropertyIndex]) ==
              2)
            Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: HomeNewsCard(
                title: "Solicitud Post Venta",
                subtitle:
                    "Si quieres solicitar una visita de postventa, ingresa una solicitud aquí y nos contactaremos con usted.",
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  RoutePaths.RequestPvi,
                ),
                asset: 'assets/images/request_card.svg',
                icon: Icons.open_in_new,
              ),
            ),
          if (PviValidator().typeProject(currentProject,
                          property.negocios![currentPropertyIndex]) !=
                      0 &&
                  currentProject.inmobiliaria!.pvi!.first.poseeSac! ||
              PviValidator().typeProject(currentProject,
                      property.negocios![currentPropertyIndex]) ==
                  0)
            HomeNewsCard(
              title: i18n("home.question_card_title"),
              subtitle: i18n("home.question_card_subtitle"),
              onPressed: () => Navigator.pushReplacementNamed(
                context,
                RoutePaths.Request,
              ),
              asset: 'assets/images/question_card.svg',
            ),
          HomeNewsCard(
              title: "Tips para tu compra",
              subtitle:
                  "Revisa las típicas dudas que todo propietario suele tener al comprar una nueva vivienda.",
              onPressed: null,
              asset: 'assets/images/tips_card.svg',
              more: () async {
                Analytics()
                    .addEventUserProject(name: 'card_tips', context: context);

                Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (c, _, __) {
                    return const DrawerFaqs();
                  },
                  transitionDuration: const Duration(seconds: 0),
                  fullscreenDialog: true,
                ));
              }),
        ],
      ),
    );
  }

  void openPostSaleDialog() {
    FocusScope.of(context).requestFocus(FocusNode());
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => PostSaleDialog(
          height: 160.h,
          title: "Post Venta",
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: SvgPicture.asset(
                  'assets/images/check.svg',
                  color: Customization.variable_1,
                ),
              ),
              Container(
                child: Text(
                  "¡Felicidades por tu nuevo hogar, \n disfruta esta nueva etapa!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
              )
            ],
          )),
    );
  }
}
