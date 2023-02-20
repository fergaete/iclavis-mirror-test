import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:iclavis/blocs/authentication/authentication_bloc.dart';
import 'package:iclavis/blocs/first_start/first_start_bloc.dart';
import 'package:iclavis/routes/routes.dart';
import 'package:iclavis/shared/textstyles_shared.dart';
import 'package:iclavis/utils/Translation/translation_extension.dart';

import '../../../../utils/extensions/analytics.dart';

final _styles = TextStylesShared();

class DrawerItem extends StatelessWidget {
  final List<String> itemsTitle;
  final List<IconData> itemsLeading;
  final List<dynamic>? itemsDrawer;
  final bool isEnabledContacts;

  const DrawerItem({
    Key? key,
    required this.itemsTitle,
    required this.itemsLeading,
    required this.isEnabledContacts,
    this.itemsDrawer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: itemsTitle.length,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (_, i) => ListTile(
        enabled: i == 2 ? isEnabledContacts : true,
        leading: Icon(
          itemsLeading[i],
          size: 24.w,
          color: Colors.black,
        ),
        title: Text(
          itemsTitle[i].i18n,
          style: _styles.mediumText(
            14.sp,
            i == 2 && !isEnabledContacts ? Colors.grey : null,
          ),
        ),
        onTap: () async {
          if (i == itemsDrawer!.length - 1) {

            await Analytics()
                .addEventUserProject(name: 'logout', context: context);
            context.read<AuthenticationBloc>().add(AuthenticationLoggedOut());
            context.read<FirstStartBloc>().add(FirstStartFlagLoaded());
            await Navigator.pushNamedAndRemoveUntil(
                context, RoutePaths.Login, (route) => false);
          } else {
            await Analytics()
                .addEventUserProject(name: 'btn_${itemsTitle[i].split('.')[1]}', context: context);
            await Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (c, _, __) {
                  return itemsDrawer![i];
                },
                transitionDuration: const Duration(seconds: 0),
                fullscreenDialog: true,
                settings: RouteSettings(name:itemsTitle[i] )
            ));
          }
        },
      ),
    );
  }
}
