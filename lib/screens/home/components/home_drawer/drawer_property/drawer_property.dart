import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'package:iclavis/blocs/project/project_bloc.dart';
import 'package:iclavis/blocs/property/property_bloc.dart';
import 'package:iclavis/blocs/user/user_bloc.dart';
import 'package:iclavis/models/project_model.dart';
import 'package:iclavis/personalizacion.dart';

import 'drawer_property_components.dart';

import '../drawer_app_bar.dart';

class DrawerProperty extends StatefulWidget {
  const DrawerProperty({Key? key}) : super(key: key);

  @override
  _DrawerPropertyState createState() => _DrawerPropertyState();
}

class _DrawerPropertyState extends State<DrawerProperty> {
  @override
  void didChangeDependencies() {
    final propertyBloc = context.read<PropertyBloc>();

    if (propertyBloc.state is! PropertySuccess) {
      final user = (context.read<UserBloc>().state as UserSuccess).user;

      List<ProjectModel> projects =
          (context.read<ProjectBloc>().state as ProjectSuccess).result.data;

      var currentProject =
          projects.firstWhere((p) => p.isCurrent, orElse: () => projects.first);

      propertyBloc.add(PropertyLoaded(
        dni: user.dni!,
        id: currentProject.proyecto!.gci!.id!,
        apiKey: currentProject.inmobiliaria!.gci!.apikey!,
      ));
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: ProfileAppBar(
          title: FlutterI18n.translate(context, "my_properties.my_properties_title"),
        ),
        body: BlocBuilder<PropertyBloc, PropertyState>(
          builder: (context, state) {
            if (state is PropertySuccess) {
              return DrawerPropertyComponents();
            } else {
              return CircularProgressIndicator(
                  backgroundColor: Customization.variable_1);
            }
          },
        ),
      ),
    );
  }
}
