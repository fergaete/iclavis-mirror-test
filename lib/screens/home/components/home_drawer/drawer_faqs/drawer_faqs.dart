import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'package:iclavis/blocs/faq/faq_bloc.dart';

import 'drawer_faqs_components.dart';
import '../drawer_app_bar.dart';

class DrawerFaqs extends StatelessWidget {
  const DrawerFaqs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FaqBloc(),
      child: SafeArea(
        child: Scaffold(
          appBar: ProfileAppBar(
            title: FlutterI18n.translate(context, "faq.purchasing_tips_title"),
          ),
          body: DrawerFaqsComponents(),
        ),
      ),
    );
  }
}
