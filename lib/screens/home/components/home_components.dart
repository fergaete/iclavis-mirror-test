import 'package:flutter/material.dart';

import 'package:iclavis/utils/Translation/translation.dart';

import '../../../models/project_model.dart';
import 'tabbar_views/tabbar_views.dart';

class HomeComponents extends StatelessWidget {
  final TabController? controller;
  final int? tabIndexSupport;
  final int? tabIndexFiles;
  final Configuraciones? config;

  const HomeComponents({
    Key? key,
    this.controller,
    this.tabIndexSupport,
    this.tabIndexFiles,
    this.config
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Translation(context);
    return TabBarView(
      controller: controller,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const HomeViews(),
        FilesViews(tabIndex: tabIndexFiles,),
        if(config!.poseePagos)
        const PaymentViews(),
        UserSupportViews(tabIndex: tabIndexSupport,),
        const NotificationsViews(),
      ],
    );
  }
}
