import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:go_router/go_router.dart';

import 'package:iclavis/personalizacion.dart';
import 'package:iclavis/routes/route_paths.dart';
import 'package:iclavis/screens/onboarding/styles.dart';

final _styles = OnboardingStyles();

class OnboardingComponents extends StatefulWidget {
  OnboardingComponents({Key? key}) : super(key: key);

  @override
  _OnboardingComponentsState createState() => _OnboardingComponentsState();
}

class _OnboardingComponentsState extends State<OnboardingComponents> {
  final PageController _pageController = PageController(
    initialPage: 0,
  );

  int currentPage = 0;

  final images = [
    'ilustracion-fotos',
    'ilustracion-documentos',
    'ilustracion-pagos',
    'ilustracion-soporte',
  ];

  @override
  Widget build(BuildContext context) {

    String i18n(String text) => FlutterI18n.translate(context, text);
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: 23.h,
          right: 26.w,
          child: InkWell(
            child: Text(
              i18n("onboarding.skip"),
              style: _styles.mediumText(14.sp),
            ),
            onTap: () =>
                GoRouter.of(context).pushReplacementNamed(
                    RouteName.PreHome),
          ),
        ),
        Positioned(
          top: 95.h,
          child: SizedBox(
            width: 360.w,
            height: 480.h,
            child: PageView(
              controller: _pageController,
              onPageChanged: (p) => setState(() => currentPage = p),
              children: List.generate(
                4,
                (i) => Column(
                  children: [
                    Image.asset(
                      "assets/images/${images[i]}.png",
                      width: 245.w,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 5.h,
                        bottom: 8.h,
                      ),
                      child: SizedBox(
                        width: 297.w,
                        child: Text(
                          titlesList(i,context),
                          style: _styles.mediumText(22.sp),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 297.w,
                      child: Text(
                        messagesList(i,context),
                        style: _styles.regularText(20.sp),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 94.h,
          child: Row(
            children: List.generate(
              4,
              (i) => Container(
                width: 20.w,
                height: 8.w,
                decoration: _styles.indicator(i == currentPage),
                child: Container(),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 40.h,
          right: 16.w,
          child: InkWell(
            child: Text(
              i18n("onboarding.next"),
              style: _styles.mediumText(14.sp, Customization.variable_1),

            ),
            onTap: () {
              if (_pageController.page == (images.length - 1)) {
                GoRouter.of(context).pushReplacementNamed(
                    RouteName.PreHome);
              }

              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.decelerate,
              );
            },
          ),
        ),
        Positioned(
          bottom: 40.h,
          left: 35.w,
          child: Visibility(
            visible: currentPage > 0,
            child: InkWell(
              child: Text(
                i18n("onboarding.previous"),
                style: _styles.regularText(14.sp, Customization.variable_1),
              ),
              onTap: () => _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.decelerate),
            ),
          ),
        ),
      ],
    );
  }

  titlesList(int i,BuildContext context ){
    final titles = [
      FlutterI18n.translate(context, "onboarding.photos_title"),
      FlutterI18n.translate(context, "onboarding.documents_title"),
      FlutterI18n.translate(context, "onboarding.payments_title"),
      FlutterI18n.translate(context, "onboarding.support_title"),
    ];
    return titles [i];
  }

  messagesList(int i,BuildContext context){
    final messages = [
      FlutterI18n.translate(context, "onboarding.photos_content"),
      FlutterI18n.translate(context, "onboarding.documents_content"),
      FlutterI18n.translate(context, "onboarding.payments_content"),
      FlutterI18n.translate(context, "onboarding.support_content"),
    ];
    return messages [i];

  }

}


