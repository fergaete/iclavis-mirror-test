import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/shared/textstyles_shared.dart';

final _styles = TextStylesShared();

class FullscreenDialog extends StatelessWidget {
  final String title;
  final String description;
  final double? width;
  final List<Widget>? widgets;
  final VoidCallback? onPressed;

  const FullscreenDialog({
    required this.title,
    required this.description,
    this.width,
    this.widgets,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: ListView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            children: <Widget>[
              Container(
                height: 131.h,
                alignment: Alignment.topRight,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.close),
                  color: Color(0xff000000).withOpacity(.54),
                  onPressed: () => onPressed!(),
                ),
              ),
              SizedBox(
                width: width ?? 245.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: width ?? 245.w,
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                        bottom: 26.h,
                      ),
                      child: Text(
                        title,
                        style: _styles.boldText(18.sp, Color(0xff463E40)),
                      ),
                    ),
                    Container(
                      width: width ?? 245.w,
                      alignment: Alignment.topLeft,
                      child: Text(
                        description,
                        style: _styles.regularText(16.sp, Color(0xff463E40)),
                      ),
                    ),
                  ],
                ),
              ),
              Column(children: widgets ?? <Widget>[]),
            ],
          ),
        ),
      ),
    );
  }
}
