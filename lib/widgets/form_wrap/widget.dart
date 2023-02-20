import 'package:flutter/material.dart';

class FormWrap extends StatelessWidget {
  final double width;
  final double paddingSize;

  final List<Widget> body;

  FormWrap({
    required this.width,
    required this.paddingSize,
    required this.body,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SingleChildScrollView(
        reverse: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Center(
          child: Container(
            width: width,
            padding: EdgeInsets.only(
              top: paddingSize,
            ),
            child: Column(
              children: body,
            ),
          ),
        ),
      ),
    );
  }
}
