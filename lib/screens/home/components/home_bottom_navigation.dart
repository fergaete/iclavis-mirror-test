import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iclavis/blocs/notification/notification_bloc.dart';
import 'package:iclavis/models/notification_model.dart';
import 'package:iclavis/models/project_model.dart';
import 'package:iclavis/personalizacion.dart';

import 'package:iclavis/shared/custom_icons.dart';
import 'package:iclavis/utils/extensions/analytics.dart';

class HomeBottomNavigation extends StatefulWidget {
  final TabController? controller;
  final int? navigationBarIndex;
  final Configuraciones? config;

  HomeBottomNavigation({
    Key? key,
    required this.controller,
    this.navigationBarIndex,
    required this.config
  }) : super(key: key);

  @override
  _HomeBottomNavigationState createState() => _HomeBottomNavigationState();
}

class _HomeBottomNavigationState extends State<HomeBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      height: 50.h,
      index: widget.navigationBarIndex ?? 0,
      items: [
        Icon(
          CustomIcons.i_home,
          size: 24.sp,
          color: Customization.variable_4,
        ),
        Icon(
          CustomIcons.i_archivos,
          size: 24.sp,
          color: Customization.variable_4,
        ),
        if(widget.config!.poseePagos)
          Icon(
            CustomIcons.i_pagos,
            size: 24.sp,
            color: Customization.variable_4,
          ),
        Icon(
          CustomIcons.i_consulta,
          size: 24.sp,
          color: Customization.variable_4,
        ),
        IconNotification(widget.controller?.index == (widget.controller!.length-1)),
      ],
      color: Customization.variable_2,
      buttonBackgroundColor: Customization.variable_2,
      backgroundColor: Colors.white,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      onTap: (i) {
        setState(() {});
        widget.controller?.animateTo(i);
        setCurrentScreen(i,context);
      },
    );
  }


  setCurrentScreen(int i,BuildContext context) async {


    final screenName = {
      0: {
        'screen':"/home",
    'analytic':'tab_home',
      },
      1:{
        'screen':'/files',
        'analytic':'tab_archivos',
      } ,
      2: {
        'screen':'/payment',
        'analytic':'tab_pagos',
      },
      3: {
        'screen':'/request',
        'analytic':'tab-consultas',
      },
      4:{
        'screen':'/notification',
        'analytic':'tab_notificaciones',
      }
    };
    await FirebaseAnalytics.instance
        .setCurrentScreen(screenName: screenName[i]!['screen'] ?? '/home');
    await Analytics().addEventUserProject(name:screenName[i]!['analytic']!,context: context);
  }
}

class IconNotification extends StatelessWidget {
  final bool isActive;

  int countNotification=0;
  List<NotificationModel> _notifications = [];
  IconNotification(this.isActive, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(

        builder: (_, state) {
          if(state is NotificationSuccess){
            _notifications = state.result.data;
            countNotification = _notifications.where((e) => e.isOpen==0).length;

            if(countNotification>0){
              FlutterAppBadger.updateBadgeCount(countNotification);
            }else{
              FlutterAppBadger.removeBadge();
            }
          }
          return Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                    color: isActive && countNotification>0 ? Colors.cyan : Colors.transparent,
                    width: 2)),
            child: Center(
              child: Stack(
                alignment: Alignment(0, 2),
                children: [
                  Icon(
                    CustomIcons.i_notificaciones,
                    size: 24.sp,
                    color: Customization.variable_4,
                  ),
                  if(countNotification>0)
                    Positioned(
                        left: 5.2,
                        top: -5.2,
                        child: Container(
                          width: 15,
                          height: 15,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.cyan,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            countNotification.toString(),
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ))
                ],
              ),
            ),
          );
        });
  }
}




setCurrentScreen(int i) async {
  final screenName = {
    0: "/home",
    1: "/files",
    2: "/payment",
    3: "/request",
    4: "/notification",
  };
  await FirebaseAnalytics.instance
      .setCurrentScreen(screenName: screenName[i] ?? '/home');
}