import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iclavis/blocs/project/project_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclavis/models/project_model.dart';
import 'package:iclavis/shared/textstyles_shared.dart';
import 'package:iclavis/shared/custom_icons.dart';

final _styles = TextStylesShared();

class CustomDrawerHeader extends StatefulWidget {
  const CustomDrawerHeader({Key? key}) : super(key: key);

  @override
  CustomDrawerHeaderState createState() => CustomDrawerHeaderState();
}

class CustomDrawerHeaderState extends State<CustomDrawerHeader> {
  late ProjectModel currentProject;

  @override
  void didChangeDependencies() {
    List<ProjectModel> projects =
        (context.read<ProjectBloc>().state as ProjectSuccess).result.data;

    currentProject = projects.firstWhere((p) => p.isCurrent == true);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 144.h,
      margin: EdgeInsets.only(left: 10.w),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(CustomIcons.i_cerrar_pantalla),
                iconSize: 24.w,
                color: const Color(0xff636363).withOpacity(.54),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          SizedBox(
            width: 274.w,
            child: AutoSizeText(
              currentProject.proyecto?.gci?.glosa ??'',
              style: _styles.boldText(16.sp),
              maxLines: 2,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.location_on,
                size: 12.1.h,
              ),
              SizedBox(
                width: 206.w,
                child: Text(
                  currentProject.proyecto?.gci?.direccion ?? '',
                  style: _styles.lightText(12.sp, const Color(0xff777777)),
                ),
              ),
            ],
          ),
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xffdAdAdA),
          ),
        ],
      ),
    );
  }
}
