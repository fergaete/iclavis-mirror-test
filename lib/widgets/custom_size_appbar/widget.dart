import 'package:flutter/material.dart';

import 'styles.dart';

final _styles = CustomSizeAppbarStyles();

class CustomSizeAppBar extends StatelessWidget {
  final AppBar appBar;

  const CustomSizeAppBar({Key? key, required this.appBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _styles.containerDecoration(appBar.backgroundColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          appBar,
        ],
      ),
    );
  }
}
