import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:iclavis/blocs/contacts/contacts_bloc.dart';
import 'package:iclavis/blocs/project/project_bloc.dart';
import 'package:iclavis/models/project_model.dart';

import 'components/components.dart';

class HomePage extends StatefulWidget {
  final int? tabIndex;
  final int? tabIndexUserSupport;
  final int? tabIndexUserFiles;

  HomePage({Key? key,  this.tabIndex,this.tabIndexUserSupport,this.tabIndexUserFiles}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

   TabController? tabController;
  late ProjectModel currentProject;
  int position = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (widget.tabIndex != null) {
      setState(() {
        position = widget.tabIndex!;
      });
    }

    final contactsState = context.read<ContactsBloc>().state;
    final List<ProjectModel> projects =
        (context.read<ProjectBloc>().state as ProjectSuccess).result.data;
    currentProject = projects.firstWhere((p) => p.isCurrent);

    configController(currentProject.inmobiliaria?.configuraciones);
    if (contactsState is! ContactsSuccess) {
      final List<ProjectModel> projects =
          (context.read<ProjectBloc>().state as ProjectSuccess).result.data;

      final currentProject = projects.firstWhere((p) => p.isCurrent);

      context.read<ContactsBloc>().add(ContactsLoaded(
            apiKey: currentProject.inmobiliaria!.gci!.apikey!,
            idProyecto: currentProject.proyecto!.gci!.id!,
          ));
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: HomeAppBar(
          scaffoldKey: _scaffoldKey,
          position: position,
          config: currentProject.inmobiliaria?.configuraciones,
        ),
        body: HomeComponents(
          controller: tabController,
          tabIndexSupport: widget.tabIndexUserSupport,
          tabIndexFiles: widget.tabIndexUserFiles,
          config: currentProject.inmobiliaria?.configuraciones,
        ),
        drawer: const HomeDrawer(),
        bottomNavigationBar: HomeBottomNavigation(
          controller: tabController,
          navigationBarIndex: position,
          config: currentProject.inmobiliaria?.configuraciones,
        ),
      ),
    );
  }

  void configController(Configuraciones? config) {
    int newInitialPosition = 0;
    if ((config == null || config.poseePagos) && tabController == null) {
      tabController = TabController(
          vsync: this, length: 5, initialIndex: widget.tabIndex ?? 0);
      if (widget.tabIndex != null) {
        setState(() {
          position = widget.tabIndex!;
        });
      }
    } else {
      if (tabController == null) {
        if (widget.tabIndex != null) {
          newInitialPosition =
          widget.tabIndex! >= 2 ? widget.tabIndex! - 1 : position;
          setState(() {
            position = newInitialPosition;
          });
        }
        tabController = TabController(
            vsync: this, length: 4, initialIndex: newInitialPosition );
      }
    }

    tabController?.addListener(() {
      setState(() {
        position = tabController!.index;
      });
    });
  }
}
