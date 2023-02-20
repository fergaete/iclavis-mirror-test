import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:iclavis/blocs/post_sale_form/post_sale_form_bloc.dart';
import 'package:iclavis/blocs/post_sale_form_data/post_sale_form_data_bloc.dart';
import 'package:iclavis/personalizacion.dart';
import 'package:iclavis/blocs/project/project_bloc.dart';
import 'package:iclavis/blocs/project_user_support/project_user_support_bloc.dart';
import 'package:iclavis/blocs/property/property_bloc.dart';
import 'package:iclavis/models/project_model.dart';
import 'package:iclavis/models/property_model.dart';
import 'package:iclavis/screens/home/components/tabbar_views/user_support_views/request_history_gci.dart';
import 'package:iclavis/shared/custom_icons.dart';
import 'package:iclavis/utils/Translation/name_utils.dart';
import 'package:iclavis/utils/extensions/analytics.dart';
import 'package:iclavis/utils/validation/pvi_validator.dart';
import 'package:iclavis/widgets/widgets.dart';

import 'new_request/new_request.dart';
import 'request_history.dart';
import 'request_postsale.dart';
import 'styles.dart';

final _styles = UserSupportViewsStyles();

class UserSupportViews extends StatefulWidget {
  final int? tabIndex;
  const UserSupportViews({super.key, this.tabIndex});

  @override
  _UserSupportViewsState createState() => _UserSupportViewsState();
}

class _UserSupportViewsState extends State<UserSupportViews>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late PropertyModel property;
  List<Negocio> properties = [];
  late Negocio selectProperties;
  int indicator = 1;
  int indicatorPvi = 2;
  bool pviSac = false;
  int pvi = 0;

  late FormularioContacto contactForm;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final state = context.read<ProjectBloc>().state;
    final propertyState = context.read<PropertyBloc>().state;
    ProjectModel? project;

    property = (propertyState as PropertySuccess).result.data;
    if (state is ProjectSuccess) {
      contactForm = (state.result.data as List<ProjectModel>)
          .firstWhere((e) => e.isCurrent)
          .proyecto!
          .gci!
          .formularioContacto!;

      project = (state.result.data as List<ProjectModel>)
          .firstWhere((e) => e.isCurrent);
    }

    pvi = PviValidator().typeProjectForPvi(project!, property.negocios!);
    if (pvi == 0) {
      _tabController = TabController(length: 2, initialIndex: 1, vsync: this);
    } else {
      if (project.inmobiliaria!.pvi!.first.poseeSac! ||
          project.inmobiliaria!.configuraciones!.poseeSac) {
        pviSac = true;
        if (widget.tabIndex != null) {
          indicator = widget.tabIndex!;
        }
        if (pvi == 1) {
          _tabController = TabController(
              length: 3,
              initialIndex: widget.tabIndex != null ? widget.tabIndex! - 1 : 1,
              vsync: this);
        } else {
          _tabController = TabController(
              length: 3, initialIndex: widget.tabIndex ?? 1, vsync: this);
        }
      } else {
        indicatorPvi = 1;
        _tabController = TabController(
            length: 2,
            initialIndex: widget.tabIndex != null ? widget.tabIndex! - 1 : 1,
            vsync: this);
      }
    }
    _tabController.addListener(_handleTabSelection);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    String i18n(String text) => FlutterI18n.translate(context, text);
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

          properties = (state.result.data as PropertyModel).negocios!;
          property = (state.result.data as PropertyModel);
          selectProperties = properties.first;
          BlocProvider.of<ProjectUserSupportBloc>(context)
              .add(ProjectUserSupportSelected(project: selectProperties));

          return MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => PostSaleFormBloc()),
                BlocProvider(create: (_) => PostSaleFormDataBloc()),
              ],
              child: GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: Column(
                  children: [
                    Container(
                        width: double.infinity,
                        height: 90.h,
                        alignment: Alignment.center,
                        child: BlocBuilder<ProjectUserSupportBloc,
                            ProjectUserSupportState>(builder: (context, state) {
                          if (state is ProjectUserSupportSelect) {
                            selectProperties = state.projectSelect;
                          }
                          return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: properties.length,
                              itemBuilder: (context, i) {
                                bool isActive = false;
                                isActive = properties[i].producto!.idGci ==
                                    selectProperties.producto!.idGci;
                                return Center(
                                  child: _BoxProperty(
                                    producto: properties[i],
                                    isActive: isActive,
                                  ),
                                );
                              });
                        })),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TabBar(
                            controller: _tabController,
                            labelColor: const Color(0xff2F2F2F),
                            indicatorColor: Colors.transparent,
                            labelPadding:
                                const EdgeInsets.symmetric(horizontal: 0.0),
                            onTap: (i) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {
                                indicator = i;
                                setCurrentScreen(i);
                              });
                            },
                            tabs: [
                              _CustomHeaderTab(
                                  icon: CustomIcons.i_historial_solicitudes,
                                  text: i18n("form.tag_history"),
                                  isActive: indicator == 0 ? true : false,
                                  controller: _tabController),
                              if (pvi == 0 ||
                                  (pvi == 1 && pviSac) ||
                                  (pvi == 2 && pviSac))
                                _CustomHeaderTab(
                                    icon: CustomIcons.i_nueva_solicitud,
                                    text: i18n("form.tag_new_request"),
                                    isActive: indicator == 1 ? true : false,
                                    controller: _tabController),
                              if (pvi == 2 || pvi == 1)
                                _CustomHeaderTab(
                                    icon: CustomIcons.i_nueva_solicitud,
                                    text: i18n("form.tag_aftersales"),
                                    isActive: indicator == indicatorPvi
                                        ? true
                                        : false,
                                    controller: _tabController)
                            ],
                          ),
                        ),
                      ],
                    ),
                    BlocBuilder<ProjectUserSupportBloc,
                        ProjectUserSupportState>(builder: (context, state) {
                      if (state is ProjectUserSupportSelect ||
                          state is ProjectUserSupportInitial) {
                        return Expanded(
                          child: _View(
                            controller: _tabController,
                            afterSaleActive: (pvi == 2),
                            pvi: pvi,
                            pviSac: pviSac,
                          ),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
                  ],
                ),
              ));
        } else if (state is PropertyFailure) {
          return Center(child: Text(state.result.message ?? ''));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  setCurrentScreen(int i) async {
    String? screenName;
    String? analyticName;
    switch (i) {
      case 0:
        screenName = "/request/history";
        analyticName = 'tab_consulta_historial';
        break;
      case 1:
        screenName = "/request/new_request";
        if (pvi == 0 || (pvi == 1 && pviSac) || (pvi == 2 && pviSac)) {
          analyticName = 'tab_consulta_sac';
        } else {
          analyticName = 'tab_consulta_postventa';
        }
        break;
      case 2:
        screenName = "/request/aftersales";
        analyticName = 'tab_consulta_postventa';
        break;
    }
    await Analytics()
        .addEventUserProject(name: analyticName ?? '', context: context);
    await FirebaseAnalytics.instance
        .setCurrentScreen(screenName: screenName ?? '');
  }
}

class _View extends StatelessWidget {
  final TabController controller;
  final bool afterSaleActive;
  final bool pviSac;
  final int pvi;

  const _View(
      {Key? key,
      required this.controller,
      this.afterSaleActive = false,
      this.pviSac = false,
      this.pvi = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Padding(
        padding: EdgeInsets.only(left: 12.w, top: 30.h, right: 12.w),
        child: TabBarView(
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            if (pvi != 0) const RequestHistory() else const RequestHistoryGci(),
            if (pvi == 0 || (pvi == 1 && pviSac) || (pvi == 2 && pviSac))
              NewRequest(
                pvi: pvi != 0,
              ),
            if (pvi == 2 || pvi == 1) RequestPostSale(),
          ],
        ),
      ),
    );
  }
}

class _CustomHeaderTab extends StatelessWidget {
  final IconData icon;
  final double? iconSize;
  final String text;
  final bool isActive;
  final TabController controller;

  const _CustomHeaderTab(
      {Key? key,
      required this.icon,
      this.iconSize,
      required this.text,
      this.isActive = false,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return controller.length == 3
        ? SizedBox(
            width: 100.w,
            height: 85.h,
            child: Card(
              elevation: 3,
              color: isActive == true
                  ? Customization.variable_2
                  : const Color(0xffe9e4dc),
              shape: _styles.cardCircularBorder(4.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 5.w, right: 5.w, top: 5.w, bottom: 5.w),
                    child: Icon(
                      icon,
                      size: iconSize ?? 35.w,
                      color: isActive == true
                          ? Customization.variable_4
                          : const Color(0xFF2F2F2F),
                    ),
                  ),
                  Text(
                    text,
                    style: _styles.lightText(
                      14.sp,
                      isActive == true
                          ? Customization.variable_4
                          : const Color(0xFF2F2F2F),
                    ),
                    maxLines: 1,
                    textScaleFactor: 1.0,
                  ),
                ],
              ),
            ),
          )
        : SizedBox(
            width: 156.w,
            height: 73.h,
            child: Card(
              elevation: 3,
              color: isActive == true
                  ? Customization.variable_2
                  : const Color(0xffe9e4dc),
              shape: _styles.cardCircularBorder(4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.w, right: 15.w),
                    child: Icon(
                      icon,
                      size: iconSize ?? 35.w,
                      color: isActive == true
                          ? Customization.variable_4
                          : const Color(0xFF2F2F2F),
                    ),
                  ),
                  Text(
                    text,
                    style: _styles.lightText(
                      14.sp,
                      isActive == true
                          ? Customization.variable_4
                          : const Color(0xFF2F2F2F),
                    ),
                    maxLines: 1,
                    textScaleFactor: 1.0,
                  ),
                ],
              ),
            ),
          );
  }
}

class _BoxProperty extends StatelessWidget {
  final Negocio producto;
  final bool isActive;

  _BoxProperty({required this.producto, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<ProjectUserSupportBloc>(context)
            .add(ProjectUserSupportSelected(project: producto));
      },
      child: Container(
          width: 160.w,
          margin: const EdgeInsets.all(10),
          child: Card(
            elevation: isActive ? 3 : 1,
            color: isActive ? const Color(0xffE9E4DC) : Colors.white,
            shape: _styles.cardCircularBorder(5.w),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          producto.producto?.tipo ?? '',
                          style:
                              _styles.lightText(12.sp, const Color(0xff2F2F2F)),
                          maxLines: 1,
                          textScaleFactor: 1.0,
                        ),
                        Text(
                          NameUtil.shortName(producto.producto?.nombre ?? ''),
                          style: _styles.mediumText(
                            14.sp,
                            const Color(0xff2F2F2F),
                          ),
                          maxLines: 1,
                          textScaleFactor: 1.0,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    CustomIcons.i_departamento,
                    color: const Color(0xff2F2F2F),
                    size: 20.sp,
                  )
                ],
              ),
            ),
          )),
    );
  }
}
