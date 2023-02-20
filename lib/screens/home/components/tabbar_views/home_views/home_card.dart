import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import "package:charcode/charcode.dart";

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclavis/blocs/project/project_bloc.dart';

import 'package:iclavis/blocs/property/property_bloc.dart';
import 'package:iclavis/models/project_model.dart';
import 'package:iclavis/models/property_model.dart';
import 'package:iclavis/personalizacion.dart';
import 'package:iclavis/routes/routes.dart';
import 'package:iclavis/utils/validation/pvi_validator.dart';
import 'package:iclavis/widgets/widgets.dart';

import 'home_time_line.dart';
import 'styles.dart';

final _styles = HomeViewsStyles();

final images = [
  "assets/images/hall_edificio.jpg",
  "assets/images/hall_condo_1.jpg",
  "assets/images/hall_condo_2.jpg"
];

class HomeCard extends StatefulWidget {
  const HomeCard({Key? key}) : super(key: key);

  @override
  _HomeCardState createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  final PageController _pageController = PageController(
    initialPage: 0,
  );

  ascii(int code) => String.fromCharCodes([code]);

  int currentPage = 0;

  late PropertyBloc propertyBloc;

  late PropertyModel property;

  late ProjectModel currentProject;

  late int currentPropertyIndex;

  @override
  void didChangeDependencies() {
    propertyBloc = context.read<PropertyBloc>();

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
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String i18n(String text) => FlutterI18n.translate(context, text);
    return Column(
      children: [
        SizedBox(
          width: 340.w,
          height: 435.h,
          child: PageView(
            controller: _pageController,
            onPageChanged: (p) => setState(() => currentPage = p),
            children: List.generate(
              property.negocios?.length??0,
              (i) => Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 13.h,
                      bottom: 23.h,
                    ),
                    child: HomeTimeLine(
                      milestoneCompleted: parseBussinessStatusToTimeLine(
                        property.negocios?[i].estado??'',
                      ),
                      colorCompleted: Customization.variable_2,
                      postSale: PviValidator()
                          .typeProject(currentProject, property.negocios![i]),
                    ),
                  ),
                  Card(
                    elevation: 3.h,
                    shadowColor: const Color(0xffdbdbdb),
                    shape: _styles.homeCardBorder,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                                return FullScreenImage(
                                    imgUrl: property
                                        .negocios?[i].producto?.modelo?.plano1??'',
                                    title: 'Planos');
                              },
                              settings: const RouteSettings(name:"/planos")
                            ))
                          },
                          child: ClipRRect(
                            borderRadius: _styles.homeCardBorderRadius,
                            child: Container(
                              width: 340.w,
                              height: 210.h,
                              padding: EdgeInsets.only(bottom: 3),
                              child: CachedNetworkImage(
                                imageUrl:
                                    property.negocios?[i].producto?.modelo?.plano1??'',
                                fit: BoxFit.contain,
                                errorWidget: (_, url, __) {
                                  return EmptyImage(
                                    innerPadding: 26.h,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              context.read<PropertyBloc>().add(
                                    CurrentPropertySaved(
                                        id: property
                                            .negocios![i].producto!.idGci!),
                                  );
                              Navigator.pushNamed(
                                  context, RoutePaths.Properties);
                            },
                            child: Container(
                              height: 127.h,
                              padding: EdgeInsets.only(
                                top: 19.h,
                                left: 6.w,
                                bottom: 17.h,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                      width: 350.w,
                                      child: AutoSizeText(
                                        "${property.proyecto?.nombre??''} ${property.negocios?[i].producto?.nombre??''}",
                                        style: _styles.boldText(16.sp),
                                        maxLines: 2,
                                        textScaleFactor: 1.0,
                                      )),
                                  Text(
                                    "${property.negocios?.first.producto?.etapa?.nombre} ",
                                    style: _styles.lightText(14.sp),
                                  ),
                                  SizedBox(
                                    width: 350.w,
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                "${property.negocios?[i].producto?.modelo?.supTotal} m${ascii($sup2)}  ${ascii($bull)}"
                                                "  ${property.negocios?[i].producto?.modelo?.cantDormitorios} ${i18n('home.Habitacion')}  ${ascii($bull)}"
                                                "  ${property.negocios?[i].producto?.modelo?.cantBanos} ${i18n('home.Baño')} "
                                                "  ${produtosSecundario(property.negocios![i].productosSecundarios!, "bodega", i18n('home.Bodega'))}"
                                                "  ${produtosSecundario(property.negocios![i].productosSecundarios!, "estacionamiento", i18n('home.Estacionamiento'))}",
                                            style: _styles.lightText(14.sp),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            property.negocios!.length,
            (i) => Container(
              width: 20.w,
              height: 8.w,
              decoration: _styles.indicatorDecoration(i == currentPage),
              child: Container(),
            ),
          ),
        ),
      ],
    );
  }
}

String produtosSecundario(
    List<ProductosSecundario> producto, String tipo, String label) {
  ascii(int code) => String.fromCharCodes([code]);

  if (producto.isEmpty) return "";
  switch (tipo.toLowerCase()) {
    case 'bodega':
      return "${ascii($bull)} ${producto.where((p) => p.tipo!.toLowerCase() == 'bodega').length} $label ";
    case 'estacionamiento':
      return "${ascii($bull)} ${producto.where((p) => p.tipo!.toLowerCase() == 'estacionamiento').length} $label ";
    default:
      return "";
  }
}

int parseBussinessStatusToTimeLine(String bussinessStatus) {
  final bussinessStatusType = {
    'promesado':3,
    'escriturado':4,
    'entregado':5,
  };
  return bussinessStatusType[bussinessStatus.toLowerCase()] ?? 1;
}
