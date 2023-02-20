import 'package:flutter/material.dart';

//import 'package:expansion_card/expansion_card.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iclavis/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'styles.dart';

class Faq extends StatefulWidget {
  final String question;
  final String answer;
  final bool isListEnd;

  const Faq({
    Key? key,
    required this.question,
    required this.answer,
    this.isListEnd = false,
  }) : super(key: key);

  @override
  _FaqState createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 40.h,
      ),
      child: Column(
        children: <Widget>[
          ListTileTheme(
            contentPadding: EdgeInsets.fromLTRB(15.w, 10.h, 10.w, 10.h),
            child: ExpansionCard(
              key: Key(widget.question),
              title: widget.question,
              icon: false,
              child: Column(
                children: [
                  const Opacity(
                      opacity: 0.4,
                      child: Divider(
                        thickness: 1,
                      )),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: EdgeInsets.only(bottom: 20.h),
                    width: 296.w,
                    child: Html(
                      data: widget.answer,
                      style: {
                        "body": Style(
                          fontSize: FontSize(14.sp),
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w300,
                        ),
                      },
                      onLinkTap: (l, _, __, ___) => launchPage(l ?? ''),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Opacity(
              opacity: 0.4,
              child: Divider(
                thickness: 1,
              )),
        ],
      ),
    );
  }

  Future launchPage(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }
}
