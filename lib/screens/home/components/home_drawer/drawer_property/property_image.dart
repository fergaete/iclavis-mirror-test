import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclavis/blocs/project/project_bloc.dart';

import 'package:iclavis/blocs/property/property_bloc.dart';
import 'package:iclavis/models/project_model.dart';
import 'package:iclavis/models/property_model.dart';
import 'package:iclavis/widgets/empty_image/widget.dart';

import 'styles.dart';

final _styles = DrawerPropertyStyles();

class PropertyImage extends StatefulWidget {
  const PropertyImage({Key? key}) : super(key: key);

  @override
  _PropertyImageState createState() => _PropertyImageState();
}

class _PropertyImageState extends State<PropertyImage> {
  late String propertyImageUrl;
  late PropertyModel property;

  late ProjectModel currentProject;

  @override
  void didChangeDependencies() {
    final projectState = context.read<ProjectBloc>().state;

    final propertyState = context.read<PropertyBloc>().state;

    if (propertyState is PropertySuccess) {
      property = propertyState.result.data;

      final negocio = property.negocios!.firstWhere(
        (e) => e.isCurrent!,
        orElse: () => property.negocios!.first,
      );

      propertyImageUrl = negocio.producto!.modelo!.plano1!;
    }

    if (projectState is ProjectSuccess) {
      currentProject = (projectState.result.data as List<ProjectModel>)
          .firstWhere((e) => e.isCurrent);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: currentProject.proyecto?.gci?.logo??'',
      imageBuilder: (_, image) {
        return Stack(
          children: [
            ClipRRect(
              borderRadius: _styles.imageBorderRadius,
              child: Container(
                width: 340.w,
                height: 193.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 14.h,
              child: Container(
                width: 130.w,
                height: 50.h,
                alignment: Alignment.center,
                padding: EdgeInsets.only(right: 5.w),
                decoration: _styles.companyDecoration,
                child: Text(
                  property.inmobiliaria?.nombre ?? '',
                  textAlign: TextAlign.right,
                  style: _styles.mediumText(14.sp, Color(0xff2f2f2f)),
                ),
              ),
            ),
          ],
        );
      },
      errorWidget: (_, url, __) {
        return SizedBox(
          width: 340.w,
          height: 193.h,
          child: EmptyImage(
            innerPadding: 25.h,
          ),
        );
      },
    );
  }
}
