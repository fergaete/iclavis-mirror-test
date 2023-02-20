import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclavis/blocs/project/project_bloc.dart';
import 'package:iclavis/blocs/user/user_bloc.dart';
import 'package:iclavis/models/project_model.dart';
import 'package:iclavis/services/user/user_repository.dart';

class Analytics {
  final _firebaseAnalytics = FirebaseAnalytics.instance;
  final UserRepository _userRepository = UserRepository();

  Future<void> addEvent(
      {required String name,  Map<String, dynamic>? parameters}) async {
    await _firebaseAnalytics.logEvent(name: name, parameters: parameters);
  }

  Future<void> addEventUser({
    required String name,
  }) async {
    final user = await _userRepository.fetchUser();
    await _firebaseAnalytics.logEvent(name: name, parameters: {
      'email': user?.email?? "",
      'rut': user?.dni?? "",
    });
  }

   Future<void> addEventUserProject(
      {required String name, required BuildContext context}) async {
    final user = (context.read<UserBloc>().state as UserSuccess).user;

      List<ProjectModel> projects =
          (context.read<ProjectBloc>().state as ProjectSuccess).result.data;
      var currentProject =
          projects.firstWhere((p) => p.isCurrent, orElse: () => projects.first);

      if(user.dni!=null && currentProject.proyecto?.gci?.id!=null){
        await _firebaseAnalytics.logEvent(name: name, parameters: {
          'rut': user.dni ?? "",
          'email': user.email ?? "",
          'proyecto': currentProject.proyecto?.gci?.id?? "",
          'nombre_proyecto': currentProject.proyecto?.gci?.glosa?? "",
        });
      }

  }
}
