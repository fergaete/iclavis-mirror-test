import 'package:flutter/material.dart';

import 'components.dart';

import '../../shared/size_config.dart';

class SplashScreenPage extends StatelessWidget {
  SplashScreenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return const SafeArea(
      child: Scaffold(
        body: SplashScreenComponents(),
      ),
    );
  }
}
