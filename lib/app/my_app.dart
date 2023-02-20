import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:flutter/material.dart' hide Router;
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_i18n/loaders/file_translation_loader.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:iclavis/screens/home/components/tabbar_views/home_views/home_view.dart';
import 'package:iclavis/services/notification/notification_manager.dart';
import 'package:iclavis/shared/support_locale.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../personalizacion.dart';
import '../routes/route_paths.dart';
import '../routes/router.dart';
import '../shared/size_config.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with RouterMixin {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final ThemeData theme = ThemeData();
  final FlutterI18nDelegate i18nDelegate = FlutterI18nDelegate(
    translationLoader: FileTranslationLoader(
      fallbackFile: "es_CL",
      useCountryCode: true,
      basePath: 'assets/i18n',
    ),
    missingTranslationHandler: (key, locale) {},
  );

  @override
  void didChangeDependencies() async {
    /* await NotificationManager.initialize(
      navigatorKey: _navigatorKey,
      context: context,
    );*/
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'iClavis',
      routerConfig: router,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        i18nDelegate,
        FormBuilderLocalizations.delegate,
      ],
      supportedLocales: CustomLocale().defaultLocale(),
      /*navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],*/
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          colorScheme:
              theme.colorScheme.copyWith(secondary: Customization.variable_1),
          progressIndicatorTheme: ProgressIndicatorThemeData(
              circularTrackColor: Colors.grey.shade50,
              color: Customization.variable_1)),
    );
  }
}
