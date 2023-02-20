import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/shared/textstyles_shared.dart';

final _styles = TextStylesShared();

class ActionLink extends StatelessWidget {
  final String link;
  final VoidCallback onTap;
  final String? question;
  final TextStyle? questionStyle;
  final TextStyle? linkStyle;

  const ActionLink({
    required this.link,
    required this.onTap,
    this.question,
    this.questionStyle,
    this.linkStyle,
    key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: RichText(
        text: TextSpan(
            text: question,
            style:
                questionStyle ?? _styles.regularText(14.sp, Color(0xff463E40)),
            children: <TextSpan>[
              TextSpan(
                text: link,
                style:
                    linkStyle ?? _styles.mediumText(14.sp, Color(0xff463E40)),
              ),
            ]),
      ),
    );
  }
}
